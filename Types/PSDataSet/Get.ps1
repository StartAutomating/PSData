<#
.SYNOPSIS
    Gets the data sets
.DESCRIPTION
    Gets the data sets from the current session.
.EXAMPLE
    Get-PSDataSet
.EXAMPLE
    ([PSCustomObject]@{PSTypeName='PSDataSet'}).Get()
#>
param()
foreach ($variable in @(Get-Variable)) {
    if ($variable.Value -is [Data.DataSet]) {
        $variable.Value
    }
}