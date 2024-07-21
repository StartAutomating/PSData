param()

@(foreach ($eventSubscriber in Get-EventSubscriber) {
    if ($eventSubscriber.SourceObject.GetHashCode() -eq $this.GetHashCode()) {        
        $eventSubscriber
    }
})