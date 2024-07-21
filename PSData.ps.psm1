$commandsPath = Join-Path $PSScriptRoot .\Commands
[include('*-*')]$commandsPath

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

$KnownVerbs = Get-Verb | Select-Object -ExpandProperty Verb
$DoNotExportTypes = @('^System\.', 'Collection$')
$DoNotExportMembers = @('\.format','^Import\.')

# Set a script variable of this, set to the module
# (so all scripts in this scope default to the correct `$this`)
$script:this = $myModule

$myDataSet = [Data.DataSet]::new($myModule.Name)
$myDataSet.Tables.Add([Data.DataTable]::new('Files'))
$myFilesTable = $myDataSet.Tables['Files']
$myFilesTable.Columns.AddRange(@(
    [Data.DataColumn]::new('Fullname', [string], '', 'Attribute'),
    [Data.DataColumn]::new('Extension', [string], '', 'Attribute'),
    [Data.DataColumn]::new('CreationTime', [datetime], '', 'Attribute'),
    [Data.DataColumn]::new('LastWriteTime', [datetime], '', 'Attribute'),
    [Data.DataColumn]::new('Length', [long], '', 'Attribute')
))
$myFilesTable.PrimaryKey = $myFilesTable.Columns['Fullname']
foreach ($foundFile in Get-ChildItem -File -Recurse -Path $PSScriptRoot) {
    $newFile = $myFilesTable.NewRow()
    $newFile.Fullname = $foundFile.FullName
    $newFile.Extension = $foundFile.Extension
    $newFile.CreationTime = $foundFile.CreationTime
    $newFile.LastWriteTime = $foundFile.LastWriteTime
    $newFile.Length = $foundFile.Length
    $null = $myFilesTable.Rows.Add($newFile)
}

$myTypesFiles = $myFilesTable.Select("Fullname LIKE '*.types.ps1xml'").Fullname -as [IO.FileInfo[]]
$myScriptTypes = $myTypesFiles | Select-Xml -Path { $_ } -XPath //Type
$myTypesTable = [Data.DataTable]::new('TypeData')
$null = $myDataSet.Tables.add($myTypesTable)
$myTypesTable.Columns.AddRange(@(
    [Data.DataColumn]::new('TypeName', [string], '', 'Attribute'),
    [Data.DataColumn]::new('MemberName', [string], '', 'Attribute')
    [Data.DataColumn]::new('Export', [bool], 'TRUE', 'Attribute')
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
        $null = $myTypesTable.Rows.Add($newTypeRow)
    }    
}

$myScriptTypeCommands = :nextMember foreach ($myScriptMember in $myTypesTable) {        
    $myMember = $myScriptMember.Member
    $myScriptType = $myScriptMember.TypeName
    foreach ($notMatch in $DoNotExportTypes) {
        if ($myScriptType -match $notMatch) { continue nextMember }
    }
    $myMemberName = $myScriptMember.MemberName    
    foreach ($notMatch in $DoNotExportMembers) {
        if ($myMemberName -match $notMatch) { continue nextMember }
    }

    if ($myMember -is [Management.Automation.Runspaces.ScriptMethodData]) {            
        $myFunctionName = 
            if ($myMemberName -in $KnownVerbs) {
                "$($myMemberName)-$($myScriptType)" -replace '[\._]',''
            } else {
                "$($myScriptType).$($myMemberName)"
            }
        # Declare My Function
        "function $myFunctionName {"
        "$($myMember.Script)"
        "}"
        if ($myMemberName -in $KnownVerbs) {
            # Alias it if it's a known verb, so both verb and noun form are available.
            "Set-Alias -Name '$($myScriptType).$($myMemberName)' -Value '$myFunctionName'"            
        }
        
        "Set-Alias -Name '$($myMemberName).$($myScriptType)' -Value '$myFunctionName'"
    }            
}

. ([ScriptBlock]::Create($myScriptTypeCommands -join [Environment]::NewLine))

Export-ModuleMember -Alias * -Function * -Variable $myModule.Name

$myModule.psobject.properties.add([psnoteproperty]::new('MyDataSet', $myDataSet), $true)
$myModule.psobject.properties.add([psnoteproperty]::new('DB', $myDataSet), $true)