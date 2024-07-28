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
    .EXAMPLE
        $myHistory = New-PSDataTable -TableName 'MyHistory' -Rows (Get-History)
        Measure-DataTable -DataTable $myHistory -ComputeExpression "AVG(Duration)"
    .EXAMPLE
        $myHistory = New-PSDataTable -TableName 'MyHistory' -Rows (Get-History)
        Measure-DataTable -DataTable $myHistory -Average Duration
    #>    
    [Alias('Measure-DataTable')]
    [CmdletBinding(PositionalBinding=$false)]
    param(
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
    $WhereExpression,

    # Calculates the average of a column.  This is a shortcut for -ComputeExpression "AVG($Average)"
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Avg')]
    [string]
    $Average,

    # Calculates the count of a column.  This is a shortcut for -ComputeExpression "COUNT($Count)"    
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Count,

    # Calculates the maximum of a column.  This is a shortcut for -ComputeExpression "MAX($Max)"
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Maximum')]
    [string]
    $Max,

    # Calculates the minimum of a column.  This is a shortcut for -ComputeExpression "MIN($Min)"
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Minimum')]
    [string]
    $Min,

    # Calculates the sum of a column.  This is a shortcut for -ComputeExpression "SUM($Sum)"
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Sum,

    # Calculates the variance of a column.  This is a shortcut for -ComputeExpression "VAR($Variance)"
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Var')]
    [string]
    $Variance,

    # Calculates the standard deviation of a column.  This is a shortcut for -ComputeExpression "STDEV($StandardDeviation)"
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('StandardDev')]
    [string]
    $StandardDeviation,    

    # The datatable object.  This is the in-memory database that you want to measure.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Table','Tables')]
    [Data.DataTable]
    $DataTable
    )

    process {
        if (-not $psBoundParameters['ComputeExpression']) {                          
            if ($Average) {
                $ComputeExpression = "AVG($Average)"
            } elseif ($Max) {
                $ComputeExpression = "MAX($Max)"
            } elseif ($Min) {
                $ComputeExpression = "MIN($Min)"
            } elseif ($Sum) {
                $ComputeExpression = "SUM($Sum)"
            } elseif ($Variance) {
                $ComputeExpression = "VAR($Variance)"
            } elseif ($StandardDeviation) {
                $ComputeExpression = "STDEV($StandardDeviation)"
            } elseif ($Count) {
                # Count should be the last option, as many objects will have a count and happily bind it to the pipeline input.
                $ComputeExpression = "COUNT($Count)"
            } 
        }
        # Compute the result from the datatable
        try {
            $DataTable.Compute($ComputeExpression, $WhereExpression)
        } catch {
            Write-Error -ErrorRecord $_
            return
        }                
    }
}