<#
.SYNOPSIS
    Gets the table names
.DESCRIPTION
    Gets the table names from the data set.
.NOTES
    When the table names are enumerated, they are added as properties to the data set.
    This makes it easier to access tables by name.
#>
@(foreach ($dataTable in $this.Tables) {
    $dataTable.TableName
    if (-not $this.psobject.properties[$dataTable.TableName]) {
        $this.psobject.properties.Add([psnoteproperty]::new($dataTable.TableName, $dataTable), $true)
    }
})