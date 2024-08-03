function Update-PSDataTable {
    <#
    .SYNOPSIS
        Updates a datatable
    .DESCRIPTION
        Updates data within a datatable, or adds new rows
    .LINK
        New-PSDataTable    
    .EXAMPLE
        $PeopleDataTable = New-PSDataTable -TableName People -Column @(
            New-PSDataColumn -ColumnName Name -ColumnType [string]
            New-PSDataColumn -ColumnName Age -ColumnType [int]
        ) -Key Name
        Update-DataTable -DataTable $PeopleDataTable -InputObject @(
            @{
                Name = "James"
                Age = 42
            }            
        ) -PassThru
    #>
    [OutputType([Data.DataRow], [Nullable])]
    [Alias('Update-DataTable')]
    [CmdletBinding(PositionalBinding=$false,SupportsShouldProcess=$true)]
    param(
    # The data to add to the data table
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [PSObject[]]
    $InputObject,
    
    # The datatable that will be updated.
    # To update multiple tables, pipe in an object with a DataTable property.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Table','Tables','DataTables')]
    [Data.DataTable]
    $DataTable,

    # If set, will return the row added to the datatable
    [Switch]
    $PassThru,

    # If set, will add columns to the table if they are not found
    [Switch]
    $Force,

    # If set, will delete and add a new row if an existing row is found
    # If not set, will change the existing row.    
    [switch]
    $Insert
    )
    
    begin {
        #region Define Simple Type Lookup Table
        $simpleTypes = ('System.Boolean', 'System.Byte[]', 'System.Byte', 'System.Char', 'System.Datetime', 'System.Decimal', 'System.Double', 'System.Guid', 'System.Int16', 'System.Int32', 'System.Int64', 'System.Single', 'System.UInt16', 'System.UInt32', 'System.UInt64')
        
        $SimpletypeLookup = @{}
        foreach ($s in $simpleTypes) {
            $SimpletypeLookup[$s] = $s
        }        
        #endregion Define Simple Type Lookup Table
    }

    process {
        # Walk over each input object
        foreach ($In in $InputObject) { 
            # and tenatively create a new row.
            $NewDataRow = $DataTable.NewRow()
            # If the input object is a data row, we will skip certain properties.
            $isDataRow = $in -is [Data.DataRow]

            # If it is a data row from this table and we already have an entry, skip it.
            if ($isDataRow -and $DataTable -eq $isDataRow.Table -and $DataTable.Rows.Contains($in)) {
                continue
            }

            # If the input object is a dictionary, we will convert it to a PSCustomObject
            if ($in -is [Collections.IDictionary]) {
                $in = [PSCustomObject]([Ordered]@{} + $in)
            }
            
            # If -Force is being used, we will add columns to the table if they are not found.
            if ($Force) {
                foreach($property in $In.PsObject.properties) {
                    # Skip certain properties if this is a data row
                    if ($isDataRow -and 'RowError', 'RowState', 'Table', 'ItemArray', 'HasErrors' -contains $property.Name) {
                        continue     
                    }
                    $propName = $property.Name
                    $propValue = $property.Value
                    $IsSimpleType = $SimpletypeLookup.ContainsKey($property.TypeNameOfValue)                    
                    
                    # If the column is not found, add it to the table.
                    if (-not $DataTable.Columns.Contains($propName)) {                        
                        $DataTable.Columns.Add((
                            [Data.DataColumn]::new(
                                $propName, 
                                $(
                                    # If it is a simple type, let that be the type.
                                    if ($issimpleType) { $property.TypeNameOfValue }
                                    # Otherwise, make it an object to support complex types.
                                    else { 'System.Object' }
                                )
                            ), '', $(
                                # If it is a simple type, make it an attribute.
                                if ($issimpleType) { 'Attribute' }
                                # Otherwise, hide it (so that it does not attempt to serialize)
                                else { 'Hidden' }
                            )
                        ))
                    }
                }
            }

            # Now that we know we have the correct set of columns, we can prepare our new row.
            foreach ($column in $DataTable.Columns) {
                $propName = $column.ColumnName
                $propValue = $in.$propName
                $IsSimpleType = $SimpletypeLookup.ContainsKey($column.DataType.FullName)
                $NewDataRow.Item($propName) = if ($isSimpleType -and ($null -ne $propValue)) {
                    $propValue
                } elseif ($propValue) {
                    [PSObject]$propValue
                } else {
                    [DBNull]::Value
                }
            }
            
            # If the table has a primary key, we will check to see if it already exists.
            if ($DataTable.PrimaryKey) {
                # Get the key columns as an array.
                $keyColumns = @($DataTable.PrimaryKey.ColumnName)
                # Find the row in the table that matches the key columns.
                $otherRow = $DataTable.Rows.Find($NewDataRow[$keyColumns])
                # If we found a row, we will either update it or replace it.
                # (the default is an upsert, unless `-Insert` was passed).
                if ($otherRow -and -not $Insert) {
                    # If it is found, update the items in the row.
                    foreach ($column in $DataTable.Columns) {
                        $propName = $column.ColumnName
                        $propValue = $NewDataRow.Item($propName)
                        $IsSimpleType = $SimpletypeLookup.ContainsKey($column.DataType.FullName)
                        $otherRow.Item($propName) = if ($isSimpleType -and $null -ne $propValue) {
                            $propValue
                        } elseif ($propValue) {
                            [PSObject]$propValue
                        } else {
                            [DBNull]::Value
                        }
                    }                    
                }
                # If an `$OtherRow` was found (and `-Insert` was passed)
                elseif ($otherRow -and $Insert) {
                    # Remove the existing row and add the new row.
                    $DataTable.Rows.Remove($otherRow)
                    $DataTable.Rows.Add($NewDataRow) 
                } else {
                    # If no Other Row was not found, add the new row.
                    $DataTable.Rows.Add($NewDataRow)
                }
            } else {
                # No key, just add it to the table.
                $DataTable.Rows.Add($NewDataRow) 
            }
            
            # If we're passing thru, return the new row.
            if ($PassThru) {
                $NewDataRow
            }  
        } 
    }
} 
