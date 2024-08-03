if ($this -is [Data.Common.DbCommand]) {
    return [PSCustomObject]@{
        PSTypeName='PSDataQuery'
        Query=$this.CommandText
        Language='SQL'
        Command=$this
    }     
}
elseif ($this -is [ScriptBlock]) {
    return [PSCustomObject]@{
        PSTypeName='PSDataQuery'
        Query=$this.ToString()
        Language='PowerShell'
        Command=$this
    }
}
elseif (
    $this -is [Management.Automation.CommandInfo] -or 
    $this -is [Management.Automation.PSVariable] -or 
    $this -is [Mangement.Automation.PSMethodInfo] -or
    $this -is [Reflection.MemberInfo]
) {
    return [PSCustomObject]@{
        PSTypeName='PSDataQuery'
        Query=$this.Name
        Language='PowerShell'
        Command=$this
    }
    return 
}

