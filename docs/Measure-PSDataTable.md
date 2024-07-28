Measure-PSDataTable
-------------------

### Synopsis
Measures a data table.

---

### Description

Measures a data table, using an expression (and optionally, a filter)

---

### Examples
> EXAMPLE 1

```PowerShell
Measure-DataTable -DataTable $psData.DB.Tables["File"] -ComputeExpression "SUM(Length)"
```
> EXAMPLE 2

```PowerShell
Measure-DataTable -DataTable $psData.DB.Tables["File"] -ComputeExpression "SUM(Length)" -WhereExpression "Extension = '.ps1'"
```

---

### Parameters
#### **DataTable**
The datatable object.  This is the in-memory database that you want to select data from.

|Type         |Required|Position|PipelineInput        |Aliases         |
|-------------|--------|--------|---------------------|----------------|
|`[DataTable]`|true    |named   |true (ByPropertyName)|Table<br/>Tables|

#### **ComputeExpression**
The expression used to measure the data.

|Type      |Required|Position|PipelineInput        |Aliases              |
|----------|--------|--------|---------------------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|Aggregate<br/>Compute|

#### **WhereExpression**
A string that specifies what rows will be selected.  This is _almost_ the same as the where clause in SQL.
For a full list of operators, [refer to Microsoft's documentation](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-data-datacolumn-expression).
Unlike full SQL, not additional commands are supported.  [Little Bobby Tables](https://xkcd.com/327/) should not hurt here.

|Type      |Required|Position|PipelineInput        |Aliases                                                                 |
|----------|--------|--------|---------------------|------------------------------------------------------------------------|
|`[String]`|false   |2       |true (ByPropertyName)|FilterExpression<br/>Condition<br/>Where<br/>WhereFilter<br/>WhereClause|

---

### Syntax
```PowerShell
Measure-PSDataTable -DataTable <DataTable> [[-ComputeExpression] <String>] [[-WhereExpression] <String>] [<CommonParameters>]
```
