Write-FormatView -TypeName 'PSDataSet', 'System.Data.DataSet' -Property TableName -VirtualProperty @{
    TableName = { $_.TableName -join [Environment]::NewLine }    
} -Wrap -Name Default -GroupByProperty DataSetName