<#
.SYNOPSIS
    Creates a new DataColumn.
.DESCRIPTION
    Creates a new DataColumn object.

    DataColumns are used to define the schema of a DataTable.
    
    They define the name, data type, and properties of a column in a DataTable.
#>
param(
# The name of the column.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Name')]
[string]
$ColumnName,

# The data type of the column.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('ParameterType','Type','DataType')]
[psobject]
$ColumnType,

# The expression used to create the column.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Expr')]
[string]
$Expression,

# The mapping type of the column (either an attribute or an element).
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('MappingType')]
[Data.MappingType]
$ColumnMapping,

# If set, the column will auto-increment.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$AutoIncrement,

# The seed value for the auto-increment.  This is the starting value.
[Parameter(ValueFromPipelineByPropertyName)]
[long]
$AutoIncrementSeed,

# The step value for the auto-increment.  This is the amount to increment by.
[Parameter(ValueFromPipelineByPropertyName)]
[long]
$AutoIncrementStep,

# The caption of the column.  This can be used by a designer.
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Caption,

# The default value of the column.
[Parameter(ValueFromPipelineByPropertyName)]
[object]
$DefaultValue,

# The max length of the column.
[Parameter(ValueFromPipelineByPropertyName)]
[int]
$MaxLength,

# The namespace of the column.
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Namespace,

# The prefix of the column.
[Parameter(ValueFromPipelineByPropertyName)]
[string]
$Prefix,

# If set, the column items must be unique.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$Unique,

# If set, the column is read-only.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$ReadOnly
)

process {    
    $myParams = [Ordered]@{} + $PSBoundParameters

    $realDataType = 
        if ($ColumnType -is [type]) {
            if ($ColumnType -eq [switch]) {
                [bool]
            } 
            elseif ($ColumnType -eq [IO.FileInfo]) {
                [string]                
            }            
            else {
                $ColumnType
            }            
        } elseif ($ColumnType -in 'number','double','single','float') {
            [double]
        } elseif ($columnType -match '^\[' -and ($ColumnType -replace '^\[' -replace '\]$') -as [type]) {
            ($ColumnType -replace '^\[' -replace '\]$') -as [type]
        }                
        else {
            [object]
        }

    $constructorArguments = @(
        if ($ColumnName) {$ColumnName}
        else {''}

        $realDataType

        if ($Expression) {
            $Expression
            if ($ColumnMapping) { $ColumnMapping }
        }
        else {
            if ($ColumnMapping) {"", $ColumnMapping}
        }        
    )

    $dataColumn = [Data.DataColumn]::new.Invoke($constructorArguments)
    if (-not $dataColumn) { return }
    foreach ($myParam in $myParams.GetEnumerator()) {
        $dataPropertyInfo = [Data.DataColumn].GetProperty($myParam.Key)
        if ($dataPropertyInfo.CanWrite) {
            $dataPropertyInfo.SetValue($dataColumn, $myParam.Value -as $dataPropertyInfo.PropertyType)
        }
    }    

    $dataColumn
}