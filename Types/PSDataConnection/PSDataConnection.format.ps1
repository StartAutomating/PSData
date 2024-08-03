Write-FormatView -TypeName PSDataConnection, 'System.Data.Common.DbConnection' -Property WorkstationId, State -Name Default -GroupByProperty DisplayName
Write-FormatView -TypeName PSDataConnection, 'System.Data.Common.DbConnection' -Property WorkstationId, ClientConnectionId, State -AutoSize -Name ID -GroupByProperty DisplayName
