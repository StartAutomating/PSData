<#
.SYNOPSIS
    Gets the progress interval.
.DESCRIPTION
    Gets the progress interval. for a DataTable.

    This is the number of items that should be processed before a progress event is raised.
.NOTES
    By default, this is 256.
#>
if (-not $this) { return }
if (-not $this.'.ProgressInterval') {
    $this.psobject.properties.add([psnoteproperty]::new('.ProgressInterval',256), $true)
}
return $this.'.ProgressInterval'