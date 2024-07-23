<#
.SYNOPSIS
    Unregisters from DataTable events
.DESCRIPTION
    Unregisters on or more subscribers from DataTable events.

    If no subscribers are provided, all subscribers will be unregistered.
#>
param(
# One or more subscribers to unregister .
[Parameter(ValueFromPipelineByPropertyName)]
[PSObject[]]
$Subscriber,

# The table to watch.  If not provided, the current object will be used.
[Data.DataTable[]]
[Alias('DataTables')]
$DataTable
)

if (-not $DataTable -and -not $this) { return }
if ($this -is [Data.DataTable] -and -not $DataTable) {
    $DataTable = $this
} elseif ($this -is [Data.DataTable]) {
    $DataTable += $this
}

if (-not $DataTable.Length) { return }
foreach ($dt in $DataTable) {
    $mySubscriptions = $dt.Subscriber
    if ($Subscriber) {
        foreach ($sub in $Subscriber) {
            $null = [Runspace]::DefaultRunspace.Events.Subscribers.Remove($sub)
        }    
    } else {
        foreach ($sub in $mySubscriptions) {
            $null = [Runspace]::DefaultRunspace.Events.Subscribers.Remove($sub)
        }
    }    
}

