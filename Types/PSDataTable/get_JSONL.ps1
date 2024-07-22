<#
.SYNOPSIS
    Gets a datatable as JSONL
.DESCRIPTION
    Gets a JSONL representation of a data table
#>
param()
if ($this -isnot [Data.DataTable]) { return }
if (-not $this.Columns.Count) { return }
$columnNames = @($this.Columns.ColumnName)
$this | Select-Object -Property $columnNames | . {process { $_  | ConvertTo-Json -Compress -Depth $this.SerializationDepth } }