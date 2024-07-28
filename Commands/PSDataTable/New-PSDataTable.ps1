function New-PSDataTable {
    <#
    .SYNOPSIS
        Creates a new table
    .DESCRIPTION
        Creates a new data table.
    .EXAMPLE
        $newDataTable = 
            New-PSDataTable -TableName 'MyTable' -TableNamespace 'MyNamespace' -Column @(
                New-PSDataColumn -ColumnName 'Index' -ColumnType ([int]) -AutoIncrement
            ) -Key Index
    .EXAMPLE
        New-PSDataTable -TableName 'MyTable' -ColumnName aString, anInt -ColumnType ([string],[int]) -Key aString
    .EXAMPLE
        $myHistory = New-PSDataTable -TableName 'MyHistory' -Rows (Get-History)
    .EXAMPLE
        $myInvocationHistory = 
            New-PSDataTable -TableName 'MyInputHistory' -Column (
                New-PSDataColumn -Column -ColumnName InputNumber -ColumnType ([int]) -AutoIncrement
                HistoryId, InvocationName, MyCommand, Parameters, Arguments 
            ) -ColumnType ([string],[string],[string],[Collections.IDictionary],[object[]]) -Key InputNumber,HistoryId        
    #>
    [Alias('New-DataTable')]
    param(
    # The name of the table.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $TableName,

    # The namespace of the table.
    # This is mainly metadata, and is the XML namespace of the table if it is serialized to XML.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $TableNamespace,

    # The prefix of the table.
    # This is used to shorten references to the table if it is serialized to XML.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $TablePrefix,

    # The columns of the table.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Columns')]
    [PSObject[]]
    $Column,

    # A list of column names.
    # Any string provided in -Column will be treated as a -ColumnName.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ColumnName,    

    # A list of column types.
    # Any type provided in -Column will be treated as a -ColumnType.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ColumnDataType')]
    [type[]]
    $ColumnType,

    # The names of key(s) of the table.  Providing multiple keys will create a composite key.
    # Keys are not required for in-memory tables (though they are still very useful)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('KeyColumn')]
    [string[]]
    $Key,

    # The rows of the table.
    [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [Alias('Rows')]
    [PSObject[]]
    $Row
    )

    process {
        # A pair of our parameters go straight to the constructor
        $constructorArgs = @(
            if ($TableName) {$TableName}
            if ($TableNamespace) {$TableNamespace}
        )

        # Create the table
        if (-not $local:NewDataTable) {
            $newDataTable = [Data.DataTable]::new.Invoke($constructorArgs)
            if ($prefix) {
                $newDataTable.Prefix = $prefix
            }
        }        

        # If column definitions were provided, we want to add them first.
        if ($Column -or $ColumnName) {
            # We also want this to be "easy", so we'll accept a string, a type or a DataColumn            
            foreach ($newColumn in $Column) {
                # If the column was a datacolumn, this is actually easy
                if ($newColumn -is [Data.DataColumn]) {
                    # we just add it if it doesn't already exist.
                    if ($newDataTable.Columns.Count -and 
                        $newDataTable.Columns[$newColumn.ColumnName]) {
                        continue
                    }
                    $null = $newDataTable.Columns.Add($newColumn)
                } 
                # If the column was a string, we'll add it to the queue
                elseif ($newColumn -is [string])
                {
                    $ColumnName += $newColumn
                } 
                # If the column was a type, we'll add all the columns in the queue as that type.
                elseif ($newColumn -is [type])
                {            
                    $ColumnType += $newColumn
                }
            }
            # If any columns are left in the queue, we'll add them as strings.
            if ($columnName.Length) {
                $typeIndex = 0
                foreach ($name in $ColumnName) {
                    if ($newDataTable.Columns.Count -and 
                        $newDataTable.Columns[$newColumn.ColumnName]) {
                        Write-Warning "Column $name was already declared"
                        continue
                    }
                    if ($columnType.Length -gt $typeIndex) {
                        $null = $newDataTable.Columns.Add($name, $columnType[$typeIndex])
                    } else {
                        $null = $newDataTable.Columns.Add($name)
                    }
                }
            }
        }

        if ($key -and $column) {
            $newDataTable.PrimaryKey = $newDataTable.Columns[$key]
        }

        if ($row) {
            $null = $newDataTable.Import($row)
        }
    }

    end {
        return , $newDataTable
    }
}

