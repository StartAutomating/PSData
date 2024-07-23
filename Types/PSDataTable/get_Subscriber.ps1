param()

if (-not $this) { return }
@(foreach ($eventSubscriber in [Runspace]::DefaultRunspace.Events.Subscribers) {
    if ($eventSubscriber.SourceObject.GetHashCode() -eq $this.GetHashCode()) {        
        $eventSubscriber
    }
})