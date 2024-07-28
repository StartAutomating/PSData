function Select-PSDatatable
{
    <#
    .Synopsis
        Selects data from an in-memory database
    .Description
        Selects data from a `[System.Data.Datatable](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable)`, which is an in-memory database.
    .Example
        $dt = dir | Select Name, LastWriteTime, LastAccessTime, CreationTime |  ConvertTo-DataTable 
        Select-DataTable -DataTable $dt -Sort LastWriteTime -SortOrder Descending
    .Link
        New-DataTable
    #>
    [OutputType([Data.DataRow])]
    [Alias('Select-DataTable')]
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The datatable object.  This is the in-memory database that you want to select data from.
    # To search multiple tables, pipe in an object with a DataTable property.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Table','Tables','DataTables')]
    [Data.DataTable]
    $DataTable,

    <#
    A string that specifies what rows will be selected.  This is _almost_ the same as the where clause in SQL.
    
    For a full list of operators, [refer to Microsoft's documentation](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-data-datacolumn-expression).

    Unlike full SQL, not additional commands are supported.  [Little Bobby Tables](https://xkcd.com/327/) should not hurt here.
    #>
    [Parameter(Position=0,ValueFromPipelineByPropertyName)]
    [Alias('FilterExpression','Condition','Where','WhereFilter','WhereClause')]
    [string]
    $WhereExpression,

    # The columns to sort.
    [Parameter(Position=1,ValueFromPipelineByPropertyName)]
    [string[]]
    $Sort,

    # The type of sort.
    [Parameter(Position=2,ValueFromPipelineByPropertyName=$true)]
    [ValidateSet("A", "Asc", "Ascending", "D", "Desc","Descending")]
    [string[]]
    $SortOrder,

    # The typename to attach to output of the datatable.  
    # This allows you to customize how the objects will be displayed in PowerShell.
    [Parameter(Position=3, ValueFromPipelineByPropertyName=$true)]
    [Alias('Decorate','Decoration','PSTypeName')]
    [string[]]$TypeName
    )

    process {
        # The "real" sort is a single sort expression
        $realSort = if ($Sort) {
            # so if -Sort was provided, we need to convert it to a single string
            @(for ($i =0; $i -lt $sort.count; $i++) {
                $s = $sort[$i]
                # if the sort order was provided, we need to append it to the sort expression
                if ($i -lt $SortOrder.Count) {
                    if ($SortOrder[$i].StartsWith("A", 'OrdinalIgnoreCase')) {
                        "$s ASC"
                    } elseif ($SortOrder[$i].StartsWith("D", 'OrdinalIgnoreCase')) {
                        "$s DESC"
                    }
                } else {
                    "$s"
                }
            }) -join ' ' 
        }

        # If no expression was provided, default to TRUE.  
        # This will select all rows, and is probably preferable to selecting no rows.
        if (-not $WhereExpression) {
            Write-Warning "No -WhereExpression was provided.  Selecting all rows."
            $WhereExpression = "TRUE"
        }
        
        # Select the rows from the datatable
        $selection = 
            if ($realSort) {
                $DataTable.Select($WhereExpression, $realSort)
            } else {
                $DataTable.Select($WhereExpression)
            }

        # If a PSTypeName was provided, add it to the selected rows
        if ($TypeName) {
            foreach ($selectedRow in $selection) {
                $selectedRow.pstypenames.clear()
                foreach ($tn in $TypeName) {
                    $selectedRow.pstypenames.add($tn)
                }
                $selectedRow
            }
        } else {
            $selection
        }
    }
}  
