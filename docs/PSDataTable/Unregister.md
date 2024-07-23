PSDataTable.Unregister()
------------------------

### Synopsis
Unregisters from DataTable events

---

### Description

Unregisters on or more subscribers from DataTable events.

If no subscribers are provided, all subscribers will be unregistered.

---

### Parameters
#### **Subscriber**
One or more subscribers to unregister .

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |1       |true (ByPropertyName)|

#### **DataTable**
The table to watch.  If not provided, the current object will be used.

|Type           |Required|Position|PipelineInput|Aliases   |
|---------------|--------|--------|-------------|----------|
|`[DataTable[]]`|false   |2       |false        |DataTables|

---
