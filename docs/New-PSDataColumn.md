New-PSDataColumn
----------------

### Synopsis
Creates a new DataColumn.

---

### Description

Creates a new DataColumn object.

DataColumns are used to define the schema of a DataTable.

They define the name, data type, and properties of a column in a DataTable.

---

### Parameters
#### **ColumnName**
The name of the column.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |1       |true (ByPropertyName)|Name   |

#### **ColumnType**
The data type of the column.
By default, this is a string.

|Type        |Required|Position|PipelineInput        |Aliases                            |
|------------|--------|--------|---------------------|-----------------------------------|
|`[PSObject]`|false   |2       |true (ByPropertyName)|ParameterType<br/>Type<br/>DataType|

#### **Expression**
The expression used to create the column.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |3       |true (ByPropertyName)|Expr   |

#### **ColumnMapping**
The mapping type of the column (either an attribute or an element).
Valid Values:

* Element
* Attribute
* SimpleContent
* Hidden

|Type           |Required|Position|PipelineInput        |Aliases    |
|---------------|--------|--------|---------------------|-----------|
|`[MappingType]`|false   |4       |true (ByPropertyName)|MappingType|

#### **AutoIncrement**
If set, the column will auto-increment.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **AutoIncrementSeed**
The seed value for the auto-increment.  This is the starting value.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int64]`|false   |5       |true (ByPropertyName)|

#### **AutoIncrementStep**
The step value for the auto-increment.  This is the amount to increment by.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int64]`|false   |6       |true (ByPropertyName)|

#### **Caption**
The caption of the column.  This can be used by a designer.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |7       |true (ByPropertyName)|

#### **DefaultValue**
The default value of the column.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|false   |8       |true (ByPropertyName)|

#### **MaxLength**
The max length of the column.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |9       |true (ByPropertyName)|

#### **Namespace**
The namespace of the column.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |10      |true (ByPropertyName)|

#### **Prefix**
The prefix of the column.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |11      |true (ByPropertyName)|

#### **Unique**
If set, the column items must be unique.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **ReadOnly**
If set, the column is read-only.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

---

### Outputs
* [Data.DataColumn](https://learn.microsoft.com/en-us/dotnet/api/System.Data.DataColumn)

---

### Syntax
```PowerShell
New-PSDataColumn [[-ColumnName] <String>] [[-ColumnType] <PSObject>] [[-Expression] <String>] [[-ColumnMapping] {Element | Attribute | SimpleContent | Hidden}] [-AutoIncrement] [[-AutoIncrementSeed] <Int64>] [[-AutoIncrementStep] <Int64>] [[-Caption] <String>] [[-DefaultValue] <Object>] [[-MaxLength] <Int32>] [[-Namespace] <String>] [[-Prefix] <String>] [-Unique] [-ReadOnly] [<CommonParameters>]
```
