$commandsPath = Join-Path $PSScriptRoot .\Commands
:ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$commandsPath" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach ($exclusion in '\.[^\.]+\.ps1$') {
        if (-not $exclusion) { continue }
        if ($file.Name -match $exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }     
    . $file.FullName
}

$myModule = $MyInvocation.MyCommand.ScriptBlock.Module
$ExecutionContext.SessionState.PSVariable.Set($myModule.Name, $myModule)
$myModule.pstypenames.insert(0, $myModule.Name)

New-PSDrive -Name $MyModule.Name -PSProvider FileSystem -Scope Global -Root $PSScriptRoot -ErrorAction Ignore

if ($home) {
    $MyModuleUserDirectory = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) $MyModule.Name    
    if (-not (Test-Path $MyModuleUserDirectory)) {
        $null = New-Item -ItemType Directory -Path $MyModuleUserDirectory -Force
    }
    New-PSDrive -Name "My$($MyModule.Name)" -PSProvider FileSystem -Scope Global -Root $MyModuleUserDirectory -ErrorAction Ignore
}

$verbs = [Data.DataTable]::new('Verbs')
$verbs.Columns.AddRange(@(
    [Data.DataColumn]::new('Verb', [string], '', 'Attribute'),
    [Data.DataColumn]::new('Description', [string], '', 'Attribute')
    [Data.DataColumn]::new('Group', [string], '', 'Attribute')
    [Data.DataColumn]::new('AliasPrefix', [string], '', 'Attribute')
))
$KnownVerbs = Get-Verb | 
    & $verbs.InputScript | 
    Sort-Object @{
        Expression={$_.Verb.Length}
    }, @{
        Expression={ $_.Verb};Descending=$false
    } -Descending | 
    Select-Object -ExpandProperty Verb

$verbs.AcceptChanges()
$DoNotExportTypes = @('^System\.', 'Collection$')
$DoNotExportMembers = @('\.format','^Import\.', '^To\.','^From\.')

# Set a script variable of this, set to the module
# (so all scripts in this scope default to the correct `$this`)
$script:this = $myModule

$myDataSet = [Data.DataSet]::new($myModule.Name)
$myDataSet.Tables.Add([Data.DataTable]::new('Directory'))
$myDirectoryTable = $myDataSet.Tables['Directory']
$myDirectoryTable.Columns.AddRange(@(
    [Data.DataColumn]::new('FullName', [string], '', 'Attribute')
    [Data.DataColumn]::new('Name', [string], '', 'Attribute')
))
$myDirectoryTable.PrimaryKey = $myDirectoryTable.Columns['Fullname']
$myDataSet.Tables.Add([Data.DataTable]::new('File'))
$myDataSet.Tables.Add($verbs)
$myFilesTable = $myDataSet.Tables['File']
$myFilesTable.Columns.AddRange(@(
    [Data.DataColumn]::new('Directory', [string], '', 'Hidden'),
    [Data.DataColumn]::new('Fullname', [string], '', 'Hidden'),
    [Data.DataColumn]::new('Name', [string], '', 'Attribute'),
    [Data.DataColumn]::new('Extension', [string], '', 'Attribute'),
    [Data.DataColumn]::new('CreationTime', [datetime], '', 'Attribute'),
    [Data.DataColumn]::new('LastWriteTime', [datetime], '', 'Attribute'),
    [Data.DataColumn]::new('Length', [long], '', 'Attribute')
))
$myDirectoryRelationship = $myDataSet.Relations.Add('File', $myDataSet.Tables['Directory'].Columns['Fullname'], $myFilesTable.Columns['Directory'])
$myDirectoryRelationship.Nested = $true
$myDirectoryRelationship.ParentKeyConstraint[0].ConstraintName = 'Directory'
$myFilesTable.PrimaryKey = $myFilesTable.Columns['Directory'], $myFilesTable.Columns['Name']
$myFolders = @(
    Get-Item -Path $PSScriptRoot
    Get-ChildItem -Directory -Recurse -Path $PSScriptRoot
)| & $myDirectoryTable.InputScript
$myFiles = Get-ChildItem -File -Recurse -Path $PSScriptRoot | & $myFilesTable.InputScript
$myFilesTable.AcceptChanges()
$myTypesFiles = $myFilesTable.Select("Fullname LIKE '*.types.ps1xml'").Fullname -as [IO.FileInfo[]]
$myScriptTypes = $myTypesFiles | Select-Xml -Path { $_ } -XPath //Type
$myTypesTable = [Data.DataTable]::new('TypeData')
$null = $myDataSet.Tables.add($myTypesTable)
$myTypesTable.Columns.AddRange(@(
    [Data.DataColumn]::new('TypeName', [string], '', 'Attribute'),
    [Data.DataColumn]::new('MemberName', [string], '', 'Attribute')
    $exportColumn = [Data.DataColumn]::new('Export', [bool], '', 'Attribute')
    $exportColumn.DefaultValue = $true
    $exportColumn
    [Data.DataColumn]::new('Member', [object])
))

$myScriptTypeData = Get-TypeData -TypeName @($myScriptTypes.Node.Name)
foreach ($myTypeData in $myScriptTypeData) {    
    if (-not $myTypeData.Members) { continue }
    foreach ($myMember in $myTypeData.Members.GetEnumerator()) {
        $newTypeRow = $myTypesTable.NewRow()
        $newTypeRow.TypeName = $myTypeData.TypeName
        $newTypeRow.MemberName = $myMember.Key
        $newTypeRow.Member = $myMember.Value
        
        :NotExported do {
            if ($newTypeRow.Member -is [Management.Automation.Runspaces.ScriptPropertyData]) {
                $newTypeRow.Export = $false
                break NotExported
            }
            if ($newTypeRow.Member -is [Management.Automation.Runspaces.AliasPropertyData] -and 
                ($myTypeData.Members[$newTypeRow.Member.ReferencedMemberName] -isnot [Management.Automation.Runspaces.ScriptMethodData])
            ) {
                $newTypeRow.Export = $false
                break NotExported
            }
            foreach ($notMatch in $DoNotExportTypes) {
                if ($newTypeRow.TypeName -match $notMatch) { 
                    $newTypeRow.Export = $false
                    break NotExported
                }
            }
            foreach ($notMatch in $DoNotExportMembers) {
                if ($myMember.Key -match $notMatch) { 
                    $newTypeRow.Export = $false
                    break NotExported
                }
            }
        } while ($false)
        
        $null = $myTypesTable.Rows.Add($newTypeRow)
    }    
}
$myTypesTable.AcceptChanges()
$startsWithKnownVerb = [regex]::new("^(?>$(@($KnownVerbs -join '|')))", 'IgnoreCase', '00:00:00.01')

$myScriptTypeCommands = foreach ($myScriptMember in $myTypesTable.Select("Export = 'True'")) {
    $myScriptType = $myScriptMember.TypeName
    $myMemberName = $myScriptMember.MemberName
    $myMember = $myScriptMember.Member
    if ($myMember -is [Management.Automation.Runspaces.ScriptMethodData]) {
        $myFunctionName = 
            if ($myMemberName -match $startsWithKnownVerb) {
                "$($matches.0)-$($myScriptType)$($myMemberName -replace $startsWithKnownVerb)" -replace '[\._]',''
            }            
            else {
                "$($myScriptType).$($myMemberName)"
            }
        # Declare My Function
        "function $myFunctionName {"
        "$($myMember.Script)"
        "}"
        if ($myMemberName -in $KnownVerbs -or $myMemberName -in 'To','From') {
            # Alias it if it's a known verb, so both verb and noun form are available.
            "Set-Alias -Name '$($myScriptType).$($myMemberName)' -Value '$myFunctionName'"            
        }
        
        "Set-Alias -Name '$($myMemberName).$($myScriptType)' -Value '$myFunctionName'"
    }            
}

. ([ScriptBlock]::Create($myScriptTypeCommands -join [Environment]::NewLine))

Export-ModuleMember -Alias * -Function * -Variable $myModule.Name

$myModule.psobject.properties.add([psnoteproperty]::new('DB', $myDataSet), $true)
$myModule.psobject.properties.add([psnoteproperty]::new('PSData', $myDataSet), $true)
