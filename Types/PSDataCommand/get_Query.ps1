if ($this -is [Data.Common.DbCommand]) {
    return $this.CommandText
}
elseif ($this -is [ScriptBlock]) {
    return $this.ToString()
}
elseif (
    $this -is [Management.Automation.CommandInfo] -or 
    $this -is [Management.Automation.PSVariable] -or 
    $this -is [Mangement.Automation.PSMethodInfo] -or
    $this -is [Reflection.MemberInfo]
) {
    return $this.Name
}

