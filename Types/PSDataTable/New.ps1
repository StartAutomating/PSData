<#
.SYNOPSIS
    Creates a new table
.DESCRIPTION
    Creates a new data table.
#>
param(
# The name of the table.
[string]
$TableName,

# The namespace of the table.
[string]
$TableNamespace,

# The prefix of the table.
# This is used to shorten references to the table if is serialized to XML.
[string]
$TablePrefix,

# The columns of the table.
[Alias('Columns')]
[PSObject[]]
$Column,

# The names of key(s) of the table.  Providing multiple keys will create a composite key.
# Keys are not required for in-memory tables (though they are still very useful)
[string[]]
$Key,

# The rows of the table.
[Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]
[Alias('Rows')]
[PSObject[]]
$Row
)

# A pair of our parameters go straight to the constructor
$constructorArgs = @(
    if ($TableName) {$TableName}
    if ($TableNamespace) {$TableNamespace}
)

# Create the table
$newDataTable = [Data.DataTable]::new.Invoke($constructorArgs)
if ($prefix) {
    $newDataTable.Prefix = $prefix
}

if ($Column) {
    foreach ($newColumn in $Column) {
        if ($newColumn -is [Data.DataColumn]) {
            if ($newDataTable.Columns.Count -and 
                $newDataTable.Columns[$newColumn.ColumnName]) {
                continue
            }
            $null = $newDataTable.Columns.Add($newColumn)
        }        
    }    
}

if ($key -and $column) {
    $newDataTable.PrimaryKey = $newDataTable.Columns[$key]
}


if ($row) {    
    $null = $newDataTable.Import($row)
}
return , $newDataTable


