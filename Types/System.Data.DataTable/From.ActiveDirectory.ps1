param(
# The directory search
[PSObject]
$Search
)

if (-not ('DirectoryServices.DirectorySearcher' -as [Type])) {
    Write-Warning "The 'System.DirectoryServices.DirectorySearcher' type is not available.  Only deserialized LDAP queries will be allowed."    
} else {
    if ($search -isnot [Directory.DirectorySearcher] -and $search -isnot [Directory.SearchResult]) {
        if ($search -is [Collections.IDictionary]) {
            $searchQuery = "($(@(foreach ($keyValue in $search.GetEnumerator()) {
                "($($keyValue.Key)=$($keyValue.Value))"
            })))"
            $search = @([Directory.DirectorySearcher]::new($searchQuery).FindAll())

        }
    } 
}

if ($this -and $this -is [Data.DataTable]) {
    $NewTable = $this 
} else {
    $NewTable = New-PSDataTable -Column LDAP -Key LDAP
}

foreach ($item in $search) {
    if (-not ($item.LDAP -and $item.Properties)) {
        continue
    }
    $itemProperties = [Ordered]@{} + $item.Properties
    $newRow = $NewTable.NewRow()
    $newRow['LDAP'] = $item.LDAP
    foreach ($itemKeyValue in $itemProperties.GetEnumerator()) {
        $columnName = $itemKeyValue.Key
        if (-not $NewTable.Columns[$columnName]) {
            $columnType = $itemKeyValue.GetType()
            $newColumnSplat = [Ordered]@{
                ColumnName = $columnName
                ColumnType = $columnType
            }
            $newColumn = New-PSDataColumn @newColumnSplat
            $NewTable.Columns.Add($newColumn)
        }
        $newRow[$columnName] = $itemKeyValue.Value
    }
}

if ($NewTable.Columns.Count -eq 1 -or $NewTable.Rows.Count -eq 0) {
    Write-Warning "No properties were found in the search results."    
}

return ,$NewTable

