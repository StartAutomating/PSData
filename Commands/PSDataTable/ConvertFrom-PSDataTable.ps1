function ConvertFrom-PSDataTable {
    <#
    .SYNOPSIS
        Converts a data table to another type
    .DESCRIPTION
        Converts a data table to another type.
        
        This can be done by using a converter, a command, or a type.
        
        If a converter is not found, this will attempt to convert the data table to the specified type.

        If a command is found, this will invoke the command with the data table as input.
        
        If a type is found, this will attempt to convert the data table to the specified type.
    #>
    [Alias('ConvertFrom-DataTable')]
    param(
    [ArgumentCompleter({
        param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
        $foundConverters = if ($psData.DB.Tables.Item) {
            $psData.DB.Tables["TypeData"].Select("TypeName = 'System.Data.DataTable' AND MemberName LIKE 'To.*'")
        }
        if (-not $foundConverters) { return }
        $foundConverters = @($foundConverters.MemberName -replace '^To\.')
        if ($WordToComplete) {
            $foundConverters -match ([Regex]::Escape($WordToComplete))
        } else {
            $foundConverters
        }
    })]
    [Alias('ConvertCommand', 'Command', 'Converter')]
    [PSObject]
    $To,

    # Any arguments to pass to the exporter
    [Parameter(ValueFromRemainingArguments)]
    [Alias('Arguments','Args')]
    [psobject[]]
    $ArgumentList,

    # The input object to the exporter.
    [Parameter(ValueFromPipeline)]
    [Alias('Input')]
    [psobject[]]
    $InputObject,

    # The parameters to pass to the command
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Parameters','Params','Options','Option')]
    [psobject[]]
    $Parameter,

    # The datatable object.  This is the in-memory database that will be converted.
    # To convert multiple tables, pipe in an object with a DataTable property.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Table','Tables','DataTables')]
    [Data.DataTable]
    $DataTable
    )

    process {
        # Conversion should be as open-ended as possible, and as easy as possible.
        
        
        # If -To was a string, we need to find the appropriate method to convert to.
        if ($to -is [string]) {
            # We'll prefer a method in the TypeData table, if it exists.
            if ($psData.DB.Tables.Item -and $(
                $foundToMethod = $psData.DB.Tables["TypeData"].Select("TypeName = 'System.Data.DataTable' AND MemberName = 'To.$to'")
                $foundToMethod
            )) {        
                $to = $foundToMethod.Member
            }
            # Next, we'll look for a command that can convert to the specified type.
            elseif ($(
                $foundToCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommands("ConvertTo-*$To",'Alias,Function,Cmdlet', $true)
                $foundToCommand
            )) {
                $to = $foundToCommand
            }
            # Finally, we'll look for a type that we could convert.
            elseif ($(
                $ToType = ($to -replace '^\[' -replace '\]$' -as [type])
                $ToType
            )) {
                $to = $ToType
            }
            else {
                Write-Error "Could not find a converter for $to"
                return
            }
        }
    
        # If -To was a ScriptMethod, we'll call it's script
        if ($to -is [Management.Automation.Runspaces.ScriptMethodData]) {
            $this = $DataTable # after we set `$this`.
            $to = $to.Script
        }
    
        # Next, let's collect any named parameters
        $namedParameters = [Ordered]@{}
        if ($parameter) {
            # everything will be joined into a dictionary.
            # The last value will overwrite the previous value.            
            foreach ($param in $parameter) {
                if ($param -is [Collections.IDictionary]) { 
                    foreach ($kv in $param.GetEnumerator()) {
                        $namedParameters[$kv.Key] = $kv.Value
                    }
                } else {
                    foreach ($psProperty in $param.psobject.Properties) {
                        $namedParameters[$psProperty.Name] = $psProperty.Value
                    }                
                }
            }
        }
    
        # If -To was something we could run, we'll run it.
        if ($to -is [Management.Automation.CommandInfo] -or 
            $to -is [ScriptBlock]
        ) {
            if ($InputObject) {
                $InputObject | & $to @ArgumentList @namedParameters
            } else {
                & $to @ArgumentList @namedParameters 
            }   
        }
        # If -To was a type, we'll convert the data table to that type.
        elseif ($to -is [type]) {
            # If an empty constructor exists, we'll use it.
            $emptyConstructorExists = $to::new.OverloadDefinitions -match '^()$'

            if (-not $emptyConstructorExists) {
                Write-Error "Could not find an empty constructor for $to"
                return
            }
            
            foreach ($row in $DataTable) {
                if ($emptyConstructorExists) {
                    [Management.Automation.LanguagePrimitives]::ConvertPSObjectToType($Row, $to, $true, [cultureinfo]::CurrentUICulture, $true)
                }
            }
        }
    }    
}
