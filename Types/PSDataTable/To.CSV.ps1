<#
.SYNOPSIS
    Gets a DataTable as CSV
.DESCRIPTION
    Gets a CSV representation of a DataTable.
#>
param()


function toCsv {
    param([string[]]$columns)
    $columns -replace # escape quotes,
        '"','""' -replace # quote items,
        '(?>^|$)','"' -join ',' # join with commas.
}

$myColumns = @($this.Columns.ColumnName)
toCsv $myColumns

foreach ($dataRow in $this.Rows) {
    toCsv $dataRow[$myColumns]
}
