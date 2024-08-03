if ($this -isnot [PSCustomObject]) {
    $this.GetType()
} else {
    $this.PSTypeNames[0]
}