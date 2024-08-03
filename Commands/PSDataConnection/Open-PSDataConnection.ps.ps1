[ValidatePattern('Open-PSDataConnection')]
param()
function Open-PSDataConnection {
    <#
    .SYNOPSIS
        Opens a data connection.
    .DESCRIPTION
        Opens a connection to a data source.        
    #>
    [Alias('Open-DataConnection')]
    param(
    # The connection to open.    
    [Parameter(ValueFromPipeline)]
    [ValidateTypes({
        [Data.Common.DbConnection],
        'PSDataConnection'
    })]
    [PSObject]
    $Connection
    )
    
    process {
        if ($connection.Open.Invoke) {
            if ($connection.OpenArguments) {
                $connection.Open.Invoke($connection.OpenArguments)
            } else {
                $connection.Open.Invoke()
            }
        }
    }
}