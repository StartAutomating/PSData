<#
.SYNOPSIS
    Gets a schema for a DataTable
.DESCRIPTION
    Gets the schema for a DataTable, as an XML Schema Definition (`.xsd`).
#>
param()
$stringWriter = [IO.StringWriter]::new()
$this.WritexmlSchema($stringWriter)
$xsd = $stringWriter.ToString()
$stringWriter.Close()
$stringWriter.Dispose()
return $xsd
