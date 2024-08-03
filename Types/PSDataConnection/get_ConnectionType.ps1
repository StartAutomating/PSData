<#
.SYNOPSIS
    Gets the type of a connection.
.DESCRIPTION
    Gets the type of a connection.
    
    If the connection is strongly defined object, it will return the type.
    If the connection is a custom object, it will return the first PSTypeName.
#>
if ($this -isnot [PSCustomObject]) {
    $this.GetType()
} else {
    $this.PSTypeNames[0]
}