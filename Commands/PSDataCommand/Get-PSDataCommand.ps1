function Get-PSDataCommand 
{
    <#
    .SYNOPSIS
        Gets data commands
    .DESCRIPTION
        Gets loaded data commands.
    .NOTES
        Will only get commands that have been saved to a variable, and are a `[Data.Common.DbCommand]`.
    #>
    [Alias('Get-DataCommand')]
    param()

    foreach ($variable in @(Get-Variable)) {
        if ($variable.Value -is [Data.Common.DbCommand] -or 
            $variable.Value.pstypenames -eq 'PSDataCommand') {
            $variable.Value
        }
    }
}
