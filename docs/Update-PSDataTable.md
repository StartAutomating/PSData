Update-PSDataTable
------------------

### Synopsis
Updates a datatable

---

### Description

Updates data within a datatable, or adds new rows

---

### Related Links
* [New-PSDataTable](New-PSDataTable.md)

---

### Examples
> EXAMPLE 1

```PowerShell
$PeopleDataTable = New-PSDataTable -TableName People -Column @(
    New-PSDataColumn -ColumnName Name -ColumnType [string]
    New-PSDataColumn -ColumnName Age -ColumnType [int]
) -Key Name
Update-DataTable -DataTable $PeopleDataTable -InputObject @(
    @{
        Name = "James"
        Age = 42
    }            
) -PassThru
```

---

### Parameters
#### **InputObject**
The data to add to the data table

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|true    |named   |true (ByValue)|

#### **DataTable**
The datatable that will be updated.
To update multiple tables, pipe in an object with a DataTable property.

|Type         |Required|Position|PipelineInput        |Aliases                        |
|-------------|--------|--------|---------------------|-------------------------------|
|`[DataTable]`|true    |named   |true (ByPropertyName)|Table<br/>Tables<br/>DataTables|

#### **PassThru**
If set, will return the row added to the datatable

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Force**
If set, will add columns to the table if they are not found

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Insert**
If set, will delete and add a new row if an existing row is found
If not set, will change the existing row.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.

If you pass ```-Confirm:$false``` you will not be prompted.

If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---

### Outputs
* [Data.DataRow](https://learn.microsoft.com/en-us/dotnet/api/System.Data.DataRow)

* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)

---

### Syntax
```PowerShell
Update-PSDataTable -InputObject <PSObject[]> -DataTable <DataTable> [-PassThru] [-Force] [-Insert] [-WhatIf] [-Confirm] [<CommonParameters>]
```
