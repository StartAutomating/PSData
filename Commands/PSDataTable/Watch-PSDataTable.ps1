function Watch-PSDataTable {
    <#
    .SYNOPSIS
        Watches a table for changes.
    .DESCRIPTION
        Watches data tables for changes, and runs one or more script blocks when the event is triggered.
    #>
    [Alias('Watch-DataTable')]
    param(
    # One or more events to watch.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('ColumnChanged', 'ColumnChanging', 'RowChanged', 'RowChanging', 'RowDeleted', 'RowDeleting', 'TableCleared', 'TableClearing', 'TableNewRow')]
    [string[]]
    $EventName,

    # One or more script blocks to run when the event is triggered.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ScriptBlock[]]
    $EventHandler,
    
    # The datatable to watch.  This is the in-memory database that you want to select data from.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Table','Tables','DataTables')]
    [Data.DataTable]
    $DataTable
    )

    process {
        $myEvents = @(Get-Member -InputObject $DataTable -MemberType Event).Name
        foreach ($nameOfEvent in $EventName) {
            if ($nameOfEvent -notin $myEvents) {
                continue
            }
            foreach ($handler in $EventHandler) {
                Register-ObjectEvent -InputObject $dt -EventName $nameOfEvent -Action $handler -SupportEvent
            }
        }
    }
}