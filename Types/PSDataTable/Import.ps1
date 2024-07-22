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
    # If a "row" was really a column, add it to the table.
    if ($inputRow -is [Data.DataColumn]) {
        $null = $aTable.Columns.Add($inputRow)
        continue nextRow
    }
    $newInputRow = $aTable.NewRow()
    # If it was already a .NET DataRow, add it to the table.
    if ($inputRow -is [Data.DataRow]) {
        # Of course, don't forget to add it's columns, first.
        foreach ($column in $inputRow.Table.Columns) {
            if (-not ($aTable.Columns.Count -and $aTable.Columns[$column.ColumnName])) {
                $null = $aTable.Columns.Add($column.ColumnName, $column.DataType)    
            }
            $columnAsType = $inputRow[$column.ColumnName] -as $aTable.Columns[$column.ColumnName].DataType
            if (-not $columnAsType) { $columnAsType = [DBNull]::Value }
            $newInputRow[$column.ColumnName] = $columnAsType
        }
        $null = $aTable.Rows.Add($newInputRow)
        continue nextRow
    }
    
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