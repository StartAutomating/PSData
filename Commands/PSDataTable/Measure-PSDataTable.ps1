function Measure-PSDataTable {
    <#
    .SYNOPSIS
        Measures a data table.
    .DESCRIPTION
        Measures a data table, using an expression (and optionally, a filter) 
    .EXAMPLE
        Measure-DataTable -DataTable $psData.DB.Tables["File"] -ComputeExpression "SUM(Length)"
    .EXAMPLE
        Measure-DataTable -DataTable $psData.DB.Tables["File"] -ComputeExpression "SUM(Length)" -WhereExpression "Extension = '.ps1'"
    #>
    
    [Alias('Measure-DataTable')]
    [CmdletBinding(PositionalBinding=$false)]
    param(    
    # The datatable object.  This is the in-memory database that you want to select data from.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Table','Tables')]
    [Data.DataTable]
    $DataTable,

    # The expression used to measure the data.
    [Parameter(Position=0,ValueFromPipelineByPropertyName)]
    [Alias('Aggregate','Compute')]
    [string]
    $ComputeExpression,

    <#
    A string that specifies what rows will be selected.  This is _almost_ the same as the where clause in SQL.
    
    For a full list of operators, [refer to Microsoft's documentation](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-data-datacolumn-expression).

    Unlike full SQL, not additional commands are supported.  [Little Bobby Tables](https://xkcd.com/327/) should not hurt here.
    #>
    [Parameter(Position=1,ValueFromPipelineByPropertyName)]
    [Alias('FilterExpression','Condition','Where','WhereFilter','WhereClause')]
    [string]
    $WhereExpression
    )

    process {        
        # Compute the result from the datatable
        try {
            $DataTable.Compute($ComputeExpression, $WhereExpression)
        } catch {
            Write-Error -ErrorRecord $_
            return
        }        
    }
}