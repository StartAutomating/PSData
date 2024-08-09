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
    [ValidateScript({
    $validTypeList = 'System.Data.Common.DbConnection','PSDataConnection'
    $thisType = @(
        if ($_.GetType) {
            $_.GetType()
        }
        $_.PSTypenames
    )
    $IsTypeOk = 
        $(@(foreach ($validTypeName in $validTypeList) {
            $realType = $validTypeName -as [type]
            foreach ($Type in $thisType) {
                if ($Type -is [type]) {
                    if ($realType) {
                        $realType -eq $type -or
                        $type.IsSubClassOf($realType) -or
                        ($realType.IsInterface -and $type.GetInterface($realType))
                    } else {
                        $type.Name -eq $realType -or 
                        $type.Fullname -eq $realType -or 
                        $type.Fullname -like $realType -or $(
                            ($realType -as [regex]) -and 
                            $type.Name -match $realType -or $type.Fullname -match $realType
                        )
                    }
                } else {
                    $type -eq $realType -or 
                    $type -like $realType -or (
                        ($realType -as [regex]) -and 
                        $type -match $realType
                    )
                }
            }
        }) -eq $true) -as [bool]
    
    if (-not $isTypeOk) {
        throw "Unexpected type '$(@($thisType)[0])'.  Must be 'System.Data.Common.DbConnection','PSDataConnection'."
    }
    return $true
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