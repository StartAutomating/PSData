<#
.SYNOPSIS
    Gets a DataTable as TSV
.DESCRIPTION
    Gets a Tab Separated Value representation of a DataTable.

    This function will return the DataTable as a TSV string.
#>
param()
function toTSV {
    param([string[]]$columns)
    $columns -replace # escape quotes,
        '"','""' -replace # quote items,
        '(?>^|$)','"' -join "`t" # join with tabs.
}
$myColumns = @($this.Columns.ColumnName)
toTSV $myColumns
foreach ($dataRow in $this.Rows) {
    toTSV $dataRow[$myColumns]
}
