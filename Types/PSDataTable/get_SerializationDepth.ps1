<#
.SYNOPSIS
    Gets the serialization depth
.DESCRIPTION
    Gets the serialization depth for a DataTable.

    This is the -Depth parameter passed to any serializer that is used to serialize the DataTable.
.NOTES
    By default, this is the `$FormatEnumerationLimit + 1`.
#>
if (-not $this) { return }
if (-not $this.'.SerializationDepth') {
    $this.psobject.properties.add([psnoteproperty]::new('.SerializationDepth',($FormatEnumerationLimit + 1)), $true)
}
return $this.'.SerializationDepth'