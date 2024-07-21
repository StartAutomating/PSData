<#
.SYNOPSIS
    Imports data into a data table
.DESCRIPTION
    Imports data into a data table.
.NOTES
    If columns do not yet exist, they will be created based on the properties of the input objects.
#>
param()

# Collect all input rows (arguments and piped input)
$arguments = @($args)
$pipedInput = @($input)

$allInputRows = @(
    $arguments | . { process { $_} }
    $pipedInput | . { process { $_} }
)

# If this was not a table
$aTable = $this
if ($aTable -isnot [Data.DataTable]) {
    # make a table.
    $aTable = [Data.DataTable]::new()
}

# Walk over each row in the table.
:nextRow foreach ($inputRow in $allInputRows) {
    if ($inputRow -is [Data.DataColumn]) {
        $null = $aTable.Columns.Add($inputRow)
        continue nextRow
    }    
    $newInputRow = $aTable.NewRow()
    $inputRowTypeNames = $inputRow.pstypenames
    :nextProperty foreach ($rowProperty in $inputRow.psobject.properties) {
        # Skip static properties from the extended type system
        if (-not $rowProperty.IsInstance) { continue nextProperty }

        if ($aTable.Columns.Count -and $aTable.Columns[$rowProperty.Name]) {
            try {
                $newInputRow[$rowProperty.Name] = $rowProperty.Value -as $aTable.Columns[$rowProperty.Name].DataType
            } catch {
                $ex = $_
                Write-Warning "Failed to set value for $($rowProperty.Name): $ex"
            }
            
            continue nextProperty
        }
        
        if ($null -ne $rowProperty.Value) {
            $rowPropertyType = $rowProperty.Value.GetType()
            if ($rowPropertyType.FullName -match '\.PS(?:Custom)Object') {
                $rowPropertyType = [object]
            }
            
            $null = $aTable.Columns.Add($rowProperty.Name, $rowPropertyType)
        } else {
            $null = $aTable.Columns.Add($rowProperty.Name, [object])
        }

        $newInputRow[$rowProperty.Name] = $rowProperty.Value -as $aTable.Columns[$rowProperty.Name].DataType
    }    
    $null = $aTable.Rows.Add($newInputRow)
}
$aTable.AcceptChanges()
return ,$aTable