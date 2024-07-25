<#
.SYNOPSIS
    Gets a data table as Clixml
.DESCRIPTION
    Gets a Clixml representation of the rows in a data table.
#>
param()
if ($this -isnot [Data.DataTable]) { return }
if (-not $this.Columns.Count) { return }
$columnNames = @($this.Columns.ColumnName)
[Management.Automation.PSSerializer]::Serialize(
    @($this | Select-Object -Property $columnNames), $FormatEnumerationLimit
)