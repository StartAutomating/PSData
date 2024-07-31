<#
.SYNOPSIS
    Create a new DataTable from a JSON Schema
.DESCRIPTION
    Create a new DataTable from a JSON Schema.

    The will create a new DataTable with columns based on the properties of the JSON Schema.    
#>
param(
# The schema object.
[PSObject]
$Schema
)

# Create a new DataTable
$tableName = if ($schema.title) {
    $schema.title
} elseif ($schema.'$id') {
    $schema.'$id'
}

if ($this -and $this -is [Data.DataTable]) {
    $NewTable = $this
    if (-not $NewTable.TableName -and $tableName) {
        $NewTable.TableName = $tableName
    }    
} else {
    $NewTable = New-PSDataTable -TableName $Schema.'$schema'    
}
$NewTable.ExtendedProperties['JsonSchema'] = $Schema

# Add columns to the DataTable from the schema properties
foreach ($schemaProperty in $schema.properties.psobject.properties) {    
    $columnName = $schemaProperty.Name
    $columnType = switch ($schemaProperty.Value.type) {
        'string' { [string] }
        'integer' { [int] }
        'number' { [double] }
        'boolean' { [bool] }
        'object' { [object] }
        'array' { [object[]] }
        default { [object] }
    }
    $newColumnSplat = [Ordered]@{
        ColumnName = $columnName
        ColumnType = $columnType
    }
    if ($schemaProperty.Value.description) {
        $newColumnSplat.Caption = $schemaProperty.Value.description
    }
    if ($schemaProperty.Value.default) {
        $newColumnSplat.DefaultValue = $schemaProperty.Value.default
    }
    $newColumn = New-PSDataColumn @newColumnSplat
    $NewTable.Columns.Add($newColumn)
}

if ($schemaProperty.required) {
    foreach ($requiredColumn in $schemaProperty.required) {
        $NewTable.Columns[$requiredColumn].AllowDBNull = $false
    }
}

return ,$NewTable