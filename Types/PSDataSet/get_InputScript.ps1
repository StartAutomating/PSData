<#
.SYNOPSIS
    Gets the input scripts for the data set
.DESCRIPTION
    Gets the input scripts for the current data set.

    Only uniquely named tables will be included in the output.
#>
$inputScripts = [Ordered]@{}
foreach ($table in $this.Tables) {    
    if (-not $table.TableName) {
        continue
    }
    $inputScripts[$table.TableName] = $table.InputScript
}
return $inputScripts