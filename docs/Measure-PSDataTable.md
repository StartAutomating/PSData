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
> EXAMPLE 3

```PowerShell
$myHistory = New-PSDataTable -TableName 'MyHistory' -Rows (Get-History)
Measure-DataTable -DataTable $myHistory -ComputeExpression "AVG(Duration)"
```
> EXAMPLE 4

```PowerShell
$myHistory = New-PSDataTable -TableName 'MyHistory' -Rows (Get-History)
Measure-DataTable -DataTable $myHistory -Average Duration
```

---

### Parameters
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

#### **Average**
Calculates the average of a column.  This is a shortcut for -ComputeExpression "AVG($Average)"

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Avg    |

#### **Count**
Calculates the count of a column.  This is a shortcut for -ComputeExpression "COUNT($Count)"

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Max**
Calculates the maximum of a column.  This is a shortcut for -ComputeExpression "MAX($Max)"

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Maximum|

#### **Min**
Calculates the minimum of a column.  This is a shortcut for -ComputeExpression "MIN($Min)"

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Minimum|

#### **Sum**
Calculates the sum of a column.  This is a shortcut for -ComputeExpression "SUM($Sum)"

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Variance**
Calculates the variance of a column.  This is a shortcut for -ComputeExpression "VAR($Variance)"

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Var    |

#### **StandardDeviation**
Calculates the standard deviation of a column.  This is a shortcut for -ComputeExpression "STDEV($StandardDeviation)"

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[String]`|false   |named   |true (ByPropertyName)|StandardDev|

#### **DataTable**
The datatable object.  This is the in-memory database that you want to measure.

|Type         |Required|Position|PipelineInput        |Aliases         |
|-------------|--------|--------|---------------------|----------------|
|`[DataTable]`|true    |named   |true (ByPropertyName)|Table<br/>Tables|

---

### Syntax
```PowerShell
Measure-PSDataTable [[-ComputeExpression] <String>] [[-WhereExpression] <String>] [-Average <String>] [-Count <String>] [-Max <String>] [-Min <String>] [-Sum <String>] [-Variance <String>] [-StandardDeviation <String>] -DataTable <DataTable> [<CommonParameters>]
```
