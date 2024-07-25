<#
.SYNOPSIS
    Gets a data table as JSON
.DESCRIPTION
    Gets a JSON representation of a data table
.NOTES
    The serialization depth can be controlled by setting `$this.SerializationDepth`.
#>
param()
if ($this -isnot [Data.DataTable]) { return }
if (-not $this.Columns.Count) { return }
$columnNames = @($this.Columns.ColumnName)
$this | Select-Object -Property $columnNames | ConvertTo-Json -Depth $this.SerializationDepth