Watch-PSDataTable
-----------------

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

|Type             |Required|Position|PipelineInput        |
|-----------------|--------|--------|---------------------|
|`[ScriptBlock[]]`|false   |2       |true (ByPropertyName)|

#### **DataTable**
The datatable to watch.  This is the in-memory database that you want to select data from.

|Type         |Required|Position|PipelineInput        |Aliases                        |
|-------------|--------|--------|---------------------|-------------------------------|
|`[DataTable]`|true    |3       |true (ByPropertyName)|Table<br/>Tables<br/>DataTables|

---

### Syntax
```PowerShell
Watch-PSDataTable [[-EventName] <String[]>] [[-EventHandler] <ScriptBlock[]>] [-DataTable] <DataTable> [<CommonParameters>]
```
