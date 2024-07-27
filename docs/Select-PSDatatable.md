Select-PSDatatable
------------------

### Synopsis
Selects data from an in-memory database

---

### Description

Selects data from a `[System.Data.Datatable](https://learn.microsoft.com/en-us/dotnet/api/system.data.datatable)`, which is an in-memory database.

---

### Related Links
* [New-DataTable](New-DataTable.md)

---

### Examples
> EXAMPLE 1

```PowerShell
$dt = dir | Select Name, LastWriteTime, LastAccessTime, CreationTime |  ConvertTo-DataTable 
Select-DataTable -DataTable $dt -Sort LastWriteTime -SortOrder Descending
```

---

### Parameters
#### **DataTable**
The datatable object.  This is the in-memory database that you want to select data from.

|Type         |Required|Position|PipelineInput        |Aliases         |
|-------------|--------|--------|---------------------|----------------|
|`[DataTable]`|true    |named   |true (ByPropertyName)|Table<br/>Tables|

#### **Expression**
A string that specifies what rows will be selected.  This is _almost_ the same as the where clause in SQL.
For a full list of operators, [refer to Microsoft's documentation](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-data-datacolumn-expression).
Unlike full SQL, not additional commands are supported.  [Little Bobby Tables](https://xkcd.com/327/) should not hurt here.

|Type      |Required|Position|PipelineInput        |Aliases                               |
|----------|--------|--------|---------------------|--------------------------------------|
|`[String]`|false   |1       |true (ByPropertyName)|DataExpression<br/>Condition<br/>Where|

#### **Sort**
The columns to sort.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|

#### **SortOrder**
The type of sort.
Valid Values:

* A
* Asc
* Ascending
* D
* Desc
* Descending

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|

#### **TypeName**
The typename to attach to output of the datatable.  
This allows you to customize how the objects will be displayed in PowerShell.

|Type        |Required|Position|PipelineInput        |Aliases                               |
|------------|--------|--------|---------------------|--------------------------------------|
|`[String[]]`|false   |4       |true (ByPropertyName)|Decorate<br/>Decoration<br/>PSTypeName|

---

### Outputs
* [Data.DataRow](https://learn.microsoft.com/en-us/dotnet/api/System.Data.DataRow)

---

### Syntax
```PowerShell
Select-PSDatatable -DataTable <DataTable> [[-Expression] <String>] [[-Sort] <String[]>] [[-SortOrder] <String[]>] [[-TypeName] <String[]>] [<CommonParameters>]
```
