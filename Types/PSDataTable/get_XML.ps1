<#
.SYNOPSIS
    Gets a DataTable as XML
.DESCRIPTION
    Gets a DataTable as XML, using the `WriteXml` method.
.NOTES
    This property will only return the XML representation of simple DataTables, whose columns are all of simple types.
    
    If this errors out, because it is a property it will simply return nothing.

    To examine the errors, look at `$Error`.
#>
param()
$stringWriter = [IO.StringWriter]::new()
$this.WriteXml($stringWriter)
$xml = $stringWriter.ToString()
$stringWriter.Close()
$stringWriter.Dispose()
return $xml
