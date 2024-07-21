Write-FormatView -TypeName PSDataConnection, 'System.Data.Common.DbConnection' -Property DastSource, WorkstationId, State -Name Default -GroupByProperty Database
Write-FormatView -TypeName PSDataConnection, 'System.Data.Common.DbConnection' -Property DataSource, WorkstationId, ClientConnectionId, State -AutoSize -Name ID
