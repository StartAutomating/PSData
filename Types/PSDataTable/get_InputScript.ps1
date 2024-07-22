<#
.SYNOPSIS
    Gets the input script for a DataTable.
.DESCRIPTION
    Dynamically creates a script block that can be used to add rows to a datatable from the pipeline.
#>

param($this = $this)
if (-not $this) { return}
$extendedProperties = [Ordered]@{} + $this.ExtendedProperties
$parameterBlock = @(
    foreach ($dataColumn in $this.Columns) {
        if ($dataColumn.ReadOnly) { continue }
        @(
            $helpLines = $(
                if ($dataColumn.Caption) { $dataColumn.Caption }
                else { $dataColumn.ColumnName }
            ) -split "(?>\r\n|\n)"

            foreach ($helpLine in $helpLines) {                
                "# $helpLine"
            }
            '[Parameter(ValueFromPipelineByPropertyName)]'
            if ($extendedProperties.Aliases -and $extendedProperties.Aliases[$dataColumn.ColumnName] )  {
                "[Alias('$($extendedProperties.Aliases[$dataColumn.ColumnName] -join "','")')]"
            }
            if ($extendedProperties.Patterns -and $extendedProperties.Patterns[$dataColumn.ColumnName]) {
                "[ValidatePattern('$($extendedProperties.Patterns[$dataColumn.ColumnName] -replace "'", "''")')]"
            }
            if ($extendedProperties.Validators -and $extendedProperties.Validators[$dataColumn.ColumnName]) {
                "[ValidateScript({$($extendedProperties.Validators[$dataColumn.ColumnName])})]"
            }
            "[$($dataColumn.DataType.FullName -replace '^System\.')]"
            "`${$($dataColumn.ColumnName)}"
        ) -join [Environment]::NewLine
    }
    @(
        '[Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline,Position=0)]'
        '[PSObject[]]'
        '$InputObject'
    ) -join [Environment]::NewLine
) -join (',' + [Environment]::NewLine)
    
$newScriptBlock = ([ScriptBlock]::Create(@"
[CmdletBinding(PositionalBinding=`$false)]
param(
$parameterBlock
)

begin {
    `$rowsAdded = [long]0
    `$ProgressId = Get-Random
    `$barberPollProgress = 0
}

process {$({
    $myCommandMetadata = [Management.Automation.CommandMetadata]$MyInvocation.MyCommand
    if ($myInvocation.MyCommand.ScriptBlock.ThisIs) {
        $local:this = $myInvocation.MyCommand.ScriptBlock.ThisIs
    }
        
    $inputObjects = @($input)
    if (-not $inputObjects -and $inputObject.Length) { $inputObjects = $inputObject }
    if (-not $inputObjects) {
        $inputObjects = @([PSCustomObject]([Ordered]@{} + $PSBoundParameters))
    }
    $progressInterval = $this.ProgressInterval

    foreach ($inObject in $inputObjects) {
        $newRow   = if ($local:this -is [Data.DataTable]) {
            $local:this.NewRow()
        }
        foreach ($myParameterName in @($myCommandMetadata.Parameters.Keys)) {         
            if ($newRow.Table -and $newRow.Table.Columns[$myParameterName]) {
                $newRow[$myParameterName] = 
                    if ($null -ne $inObject.$myParameterName) {
                        $inObject.$myParameterName -as $newRow.Table.Columns[$myParameterName].DataType
                    } else {
                        [DBNull]::Value
                    }                
            }
        }
        if ($newRow) {
            $null = $newRow.Table.Rows.Add($newRow)
            if ($progressInterval -and -not ($rowsAdded % $progressInterval)) {
                $barberPollProgress += 5
                if ($barberPollProgress -gt 100) { $barberPollProgress = 0 }
                Write-Progress -Id $ProgressId -Activity "Adding rows $($this.TableName)" -Status "$rowsAdded rows" -PercentComplete $barberPollProgress
            }
            $rowsAdded++
        }
        $inObject
    }
})
}

end {
    Write-Progress -Id `$ProgressId -Activity "Adding rows $($this.TableName)" -Status "$rowsAdded rows" -Completed
}
"@))
$newScriptBlock.psobject.properties.add([psnoteproperty]::new('ThisIs', $this), $true)
    
return $newScriptBlock


