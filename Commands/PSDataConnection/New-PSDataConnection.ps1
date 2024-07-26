function New-PSDataConnection {
    <#
    .SYNOPSIS
        Creates a new connection to a data source
    .DESCRIPTION
        Creates a new connection to a data source (usually a database).

        By default, this tries to use the `System.Data.SqlClient.SqlConnection` type.
        
        An alternate typename can be specified by providing the `-ConnectionTypeName` parameter.
    #>
    [Alias('New-DataConnection')]
    param(
    # The connection secret (or connection string, if you are brave).
    # If a secret is provided, it will be used to retrieve the connection string.
    # This will require the Microsoft.PowerShell.SecretManagement module.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ConnectionString', 'ConnectionStringOrSecret')]
    [string]
    $ConnectionSecret,

    # The name of the vault to use to retrieve the connection secret.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $VaultName,

    # The type name of connection type.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ConnectionTypeName,

    # The assembly location of the data adapter to use.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('AssemblyPath')]
    [string]
    $AssemblyLocation
    )

    if (-not $connectionTypeName) {
        $connectionTypeName = 'System.Data.SqlClient.SqlConnection'
    }
    if (-not ($ConnectionTypeName -as [type])) {
        if ($AssemblyLocation) {
            Add-Type -Path $AssemblyLocation
        }    
    }

    $connectionType = $connectionTypeName -as [type]
    if (-not $connectionType -or -not $connectionType.GetConstructors()) {
        throw "Unable to create an instance of $connectionType"
    }

    $ConnectionString = 
        if ($connectionSecret -match '\;') {
            $connectionSecret
        } else {
            $secretSplat = [Ordered]@{Name=$ConnectionSecret}
            if ($VaultName) {
                $secretSplat.VaultName = $VaultName
            }
            Get-Secret @secretSplat -AsPlainText
        }

    $connectionType::new($connectionString)
}