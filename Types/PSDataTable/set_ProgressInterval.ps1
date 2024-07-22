<#
.SYNOPSIS
    Sets the progress interval.
.DESCRIPTION
    Sets the progress interval for a DataTable.

    This is the number of items that should be processed before a progress event is raised.
.NOTES
    By default, this is 256.
#>
param([int]$ProgressInterval = 256)
if (-not $this) { return }
$this.psobject.properties.add([psnoteproperty]::new('.ProgressInterval',$ProgressInterval), $true)
return $this.'.ProgressInterval'