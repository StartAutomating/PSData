[ValidatePattern('Close-PSDataConnection')]
param()
function Close-PSDataConnection {
    <#
    .SYNOPSIS
        Closes a data connection.
    .DESCRIPTION
        Closes a connection to a data source.        
    #>
    [Alias('Close-DataConnection')]
    param(
    # The connection to close.
    [Parameter(ValueFromPipeline)]
    [ValidateTypes({
        [Data.Common.DbConnection],
        'PSDataConnection'
    })]
    [PSObject]
    $Connection
    )
    
    process {
        if ($connection.Close.Invoke) {
            if ($connection.CloseArguments) {
                $connection.Close.Invoke($connection.CloseArguments)
            } else {
                $connection.Close.Invoke()
            }
        }
    }
}