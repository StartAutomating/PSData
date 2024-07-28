<#
.SYNOPSIS
    Gets a data table as binary
.DESCRIPTION
    Gets a binary representation of the data table.

    If any objects in the datatable are not serializable, an error will be thrown.
#>
param()
if ($this -isnot [Data.DataTable]) { return }
# if (-not $this.Columns.Count) { return }
$columnNames = @($this.Columns.ColumnName)
$binaryFormatter = [Runtime.Serialization.Formatters.Binary.BinaryFormatter]::new()
$memoryStream = [IO.MemoryStream]::new()
$binaryFormatter.Serialize($memoryStream, $this)
$memoryStream.ToArray()
$memoryStream.Dispose()