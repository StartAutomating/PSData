<#
.SYNOPSIS
    Sets the serialization depth
.DESCRIPTION
    Sets the serialization depth for a DataTable.

    This is the -Depth parameter passed to any serializer that is used to serialize the DataTable.
.NOTES
    By default, this is `$FormatEnumerationLimit + 1`.
#>
param([int]$Depth)

if (-not $this) { return }

$this.psobject.properties.add([psnoteproperty]::new('.SerializationDepth',$Depth), $true)
return $this.'.SerializationDepth'