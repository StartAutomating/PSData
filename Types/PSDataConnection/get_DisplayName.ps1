<#
.SYNOPSIS
    Gets the display name of a connection.
.DESCRIPTION
    Gets the display name of a connection.
    
    If the connection has a custom DisplayName property, it will return that.
    
    Otherwise, the `.Database` will be returned.
#>
if ($this.psobject.properties['.DisplayName']) {
    $this.psobject.properties['.DisplayName'].Value
} elseif ($this.Database) {
    $this.Database
}

