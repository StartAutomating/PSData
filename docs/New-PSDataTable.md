New-PSDataTable
---------------

### Synopsis
Creates a new table

---

### Description

Creates a new data table.

---

### Examples
> EXAMPLE 1

```PowerShell
$newDataTable = 
    New-PSDataTable -TableName 'MyTable' -TableNamespace 'MyNamespace' -Column @(
        New-PSDataColumn -ColumnName 'Index' -ColumnType ([int]) -AutoIncrement
    ) -Key Index
```
> EXAMPLE 2

```PowerShell
New-PSDataTable -TableName 'MyTable' -ColumnName aString, anInt -ColumnType ([string],[int]) -Key aString
```
> EXAMPLE 3

```PowerShell
$myHistory = New-PSDataTable -TableName 'MyHistory' -Rows (Get-History)
```
> EXAMPLE 4

$myInvocationHistory = 
    New-PSDataTable -TableName 'MyInputHistory' -Column (
        New-PSDataColumn -Column -ColumnName InputNumber -ColumnType ([int]) -AutoIncrement
        HistoryId, InvocationName, MyCommand, Parameters, Arguments 
    ) -ColumnType ([string],[string],[string],[Collections.IDictionary],[object[]]) -Key InputNumber,HistoryId

---

### Parameters
#### **TableName**
The name of the table.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **TableNamespace**
The namespace of the table.
This is mainly metadata, and is the XML namespace of the table if it is serialized to XML.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **TablePrefix**
The prefix of the table.
This is used to shorten references to the table if it is serialized to XML.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **Column**
The columns of the table.

|Type          |Required|Position|PipelineInput        |Aliases|
|--------------|--------|--------|---------------------|-------|
|`[PSObject[]]`|false   |4       |true (ByPropertyName)|Columns|

#### **ColumnName**
A list of column names.
Any string provided in -Column will be treated as a -ColumnName.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |5       |true (ByPropertyName)|

#### **ColumnType**
A list of column types.
Any type provided in -Column will be treated as a -ColumnType.

|Type      |Required|Position|PipelineInput        |Aliases       |
|----------|--------|--------|---------------------|--------------|
|`[Type[]]`|false   |6       |true (ByPropertyName)|ColumnDataType|

#### **Key**
The names of key(s) of the table.  Providing multiple keys will create a composite key.
Keys are not required for in-memory tables (though they are still very useful)

|Type        |Required|Position|PipelineInput        |Aliases  |
|------------|--------|--------|---------------------|---------|
|`[String[]]`|false   |7       |true (ByPropertyName)|KeyColumn|

#### **Row**
The rows of the table.

|Type          |Required|Position|PipelineInput                 |Aliases|
|--------------|--------|--------|------------------------------|-------|
|`[PSObject[]]`|false   |8       |true (ByValue, ByPropertyName)|Rows   |

---

### Syntax
```PowerShell
New-PSDataTable [[-TableName] <String>] [[-TableNamespace] <String>] [[-TablePrefix] <String>] [[-Column] <PSObject[]>] [[-ColumnName] <String[]>] [[-ColumnType] <Type[]>] [[-Key] <String[]>] [[-Row] <PSObject[]>] [<CommonParameters>]
```
