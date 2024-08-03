<#
.SYNOPSIS
    Sets the display name of a connection.
.DESCRIPTION
    Sets the displayed name of a connection.
#>
param([string]$DisplayName)

$this.psobject.properties.Add(
    [psnoteproperty]::new('.DisplayName', $DisplayName), $true
)