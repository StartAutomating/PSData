Write-FormatView -TypeName 'PSDataSet', 'System.Data.DataSet' -Property DataSetName, TableName -VirtualProperty @{
    TableName = { $_.TableName -join [Environment]::NewLine }    
} -Wrap -Name Default