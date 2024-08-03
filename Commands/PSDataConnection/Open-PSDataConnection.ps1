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
        if ($connection.Open.Invoke) {
            if ($connection.OpenArguments) {
                $connection.Open.Invoke($connection.OpenArguments)
            } else {
                $connection.Open.Invoke()
            }
        }
    }

}
