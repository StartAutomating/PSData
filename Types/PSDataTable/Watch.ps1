<#
.SYNOPSIS
    Watches a table for changes.
#>
param(
# One or more events to watch.
[Parameter(ValueFromPipelineByPropertyName)]
[ValidateSet('ColumnChanged', 'ColumnChanging', 'RowChanged', 'RowChanging', 'RowDeleted', 'RowDeleting', 'TableCleared', 'TableClearing', 'TableNewRow')]
[string[]]
$EventName,

# One or more script blocks to run when the event is triggered.
[ScriptBlock[]]
$EventHandler,

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
    $myEvents = @(Get-Member -InputObject $dt -MemberType Event).Name
    foreach ($nameOfEvent in $EventName) {
        if ($nameOfEvent -notin $myEvents) {
            continue
        }
        foreach ($handler in $EventHandler) {
            Register-ObjectEvent -InputObject $dt -EventName $nameOfEvent -Action $handler -SupportEvent
        }
    }
}


