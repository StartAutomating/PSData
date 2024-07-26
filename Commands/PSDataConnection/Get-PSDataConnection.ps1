function Get-PSDataConnection {
    <#
    .SYNOPSIS
        Gets data connections
    .DESCRIPTION
        Gets loaded data connections.
    .NOTES
        Will only get connections that have been saved to a variable, and are a `[Data.Common.DbConnection]`.
    #>
    [Alias('Get-DataConnection')]
    param()

    foreach ($variable in @(Get-Variable)) {
        if ($variable.Value -is [Data.Common.DbConnection]) {
            $variable.Value
        }
    }
}