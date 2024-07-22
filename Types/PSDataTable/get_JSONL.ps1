<#
.SYNOPSIS
    Gets a datatable as JSONL
.DESCRIPTION
    Gets a JSONL representation of a data table.

    JSONL is a format where each line is a JSON object.
.NOTES
    The serialization depth can be controlled by setting `$this.SerializationDepth`.
#>
param()
if ($this -isnot [Data.DataTable]) { return }
if (-not $this.Columns.Count) { return }
$columnNames = @($this.Columns.ColumnName)
$this | Select-Object -Property $columnNames | . {process { $_  | ConvertTo-Json -Compress -Depth $this.SerializationDepth } }