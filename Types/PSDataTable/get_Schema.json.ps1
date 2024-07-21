<#
.SYNOPSIS
    Gets a schema for a DataTable
.DESCRIPTION
    Gets the schema for a DataTable, as a [JSON schema](https://json-schema.org/).
#>
$jsonSchema = [Ordered]@{
    type = 'object'
    properties = [Ordered]@{}
}
foreach ($column in $this.Columns) {
    $jsonSchema.properties[$column.ColumnName] = [Ordered]@{        
        type = switch ($column.DataType) {
            {$_ -eq [System.String]} { 'string' }
            {$_ -eq [System.Int32]} { 'integer' }
            {$_ -eq [System.Int64]} { 'integer' }
            {$_ -in [Double], [float]} { 'number' }
            {$_ -eq [DateTime]} { 'string' }
            {$_ -eq [Boolean], [switch]} { 'boolean' }
            {$_.IsEnum} { 'enum' }
            default { 'object' }
        }        
    }
    if ($column.DefaultValue -ne [System.DBNull]::Value) {
        $jsonSchema.properties[$column.ColumnName].default = $column.DefaultValue
    }
    if ($column.Caption) {
        $jsonSchema.properties[$column.ColumnName].description = $column.Caption
    }
}
return ($jsonSchema | ConvertTo-Json -Depth 10)