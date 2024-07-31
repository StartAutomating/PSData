param(
# The directory search
[PSObject]
$Search
)

if (-not ('DirectoryServices.DirectorySearcher' -as [Type])) {
    Write-Warning "The 'System.DirectoryServices.DirectorySearcher' type is not available.  Only deserialized LDAP queries will be allowed."    
} else {
    if ($search -isnot [DirectoryServices.DirectorySearcher] -and $search -isnot [DirectoryServices.SearchResult]) {
        if ($search -is [Collections.IDictionary]) {
            $searchQuery = "($(@(foreach ($keyValue in $search.GetEnumerator()) {
                "($($keyValue.Key)=$($keyValue.Value))"
            })))"
            $search = [DirectoryServices.DirectorySearcher]::new($searchQuery)
        }
        elseif ($search -is [string]) {
            $search = [DirectoryServices.DirectorySearcher]::new($search)
        }        
    }
    if ($search -is [DirectoryServices.DirectorySearcher]) {
        Write-Verbose "Searching Active Directory for '$($search.Filter)'"
        $search = @($search.FindAll())
        Write-Verbose "Searching Active Directory for '$($search.Length)' results found" 
    }
}

if ($this -and $this -is [Data.DataTable]) {
    $NewTable = $this
    if (-not $this.Columns['Path']) {
        $NewTable.Columns.Add((New-PSDataColumn -ColumnName Path -ColumnType ([string])))
    }
    $NewTable.PrimaryKey = $NewTable.Columns['Path']
} else {
    $NewTable = New-PSDataTable -Column Path -Key Path
}

$skipCount = 0
foreach ($item in $search) {
    if ((-not $item.Path) -and (-not $item.Properties)) {
        $skipCount++
        continue
    }
    $itemProperties = [Ordered]@{} + $item.Properties
    $newRow = $NewTable.NewRow()
    $newRow['Path'] = $item.Path
    foreach ($itemKeyValue in $itemProperties.GetEnumerator()) {
        $columnName = $itemKeyValue.Key
        $newColumnSplat = [Ordered]@{
            ColumnName = $columnName        
        }        
        $columnData = @($itemKeyValue.Value)
        $columnType = 
            if ($columnData.Length -gt 1) {
                "$($columnData[0].GetType().FullName)[]" -as ([Type])
            } else {
                $columnData[0].GetType()
            }
        if ($columnType -eq [string] -and $columnName -notmatch '(?>name|path)$') {
            $columnType = [string[]]
        }
        $unrollColumnData = $columnData | . { process { $_ }}
        $newColumnSplat.ColumnType = $columnType        
        if (-not $NewTable.Columns[$columnName]) {                   
            $newColumn = New-PSDataColumn @newColumnSplat
            $NewTable.Columns.Add($newColumn)
        }
        $columnDataInType = $unrollColumnData -as $newColumnSplat.ColumnType
        if ($null -eq $columnDataInType) {
            $columnDataInType = [DBNull]::Value
        }
        try {
            $newRow[$columnName] = $columnDataInType
        } catch {
            Write-Error "Failed to set value for column '$columnName' with type '$($newColumnSplat.ColumnType.FullName)': $_"
            return
        }            
    }
    $NewTable.Rows.Add($newRow)
}

if ($skipCount -gt 0) {
    Write-Warning "Skipped $skipCount items that did not have LDAP or Properties."    
}

if ($NewTable.Columns.Count -eq 1 -or $NewTable.Rows.Count -eq 0) {
    Write-Warning "No properties were found in the search results."    
}

return ,$NewTable

