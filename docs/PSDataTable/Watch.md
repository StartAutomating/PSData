PSDataTable.Watch()
-------------------

### Synopsis
Watches a table for changes.

---

### Description

Watches data tables for changes, and runs one or more script blocks when the event is triggered.

---

### Parameters
#### **EventName**
One or more events to watch.
Valid Values:

* ColumnChanged
* ColumnChanging
* RowChanged
* RowChanging
* RowDeleted
* RowDeleting
* TableCleared
* TableClearing
* TableNewRow

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |1       |true (ByPropertyName)|

#### **EventHandler**
One or more script blocks to run when the event is triggered.

|Type             |Required|Position|PipelineInput|
|-----------------|--------|--------|-------------|
|`[ScriptBlock[]]`|false   |2       |false        |

#### **DataTable**
The table to watch.  If not provided, the current object will be used.

|Type           |Required|Position|PipelineInput|Aliases   |
|---------------|--------|--------|-------------|----------|
|`[DataTable[]]`|false   |3       |false        |DataTables|

---
