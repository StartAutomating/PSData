ConvertFrom-PSDataTable
-----------------------

### Synopsis
Converts a data table to another type

---

### Description

Converts a data table to another type.

This can be done by using a converter, a command, or a type.

If a converter is not found, this will attempt to convert the data table to the specified type.

If a command is found, this will invoke the command with the data table as input.

If a type is found, this will attempt to convert the data table to the specified type.

---

### Parameters
#### **To**

|Type        |Required|Position|PipelineInput|Aliases                                 |
|------------|--------|--------|-------------|----------------------------------------|
|`[PSObject]`|false   |1       |false        |ConvertCommand<br/>Command<br/>Converter|

#### **ArgumentList**
Any arguments to pass to the exporter

|Type          |Required|Position|PipelineInput|Aliases           |
|--------------|--------|--------|-------------|------------------|
|`[PSObject[]]`|false   |2       |false        |Arguments<br/>Args|

#### **InputObject**
The input object to the exporter.

|Type          |Required|Position|PipelineInput |Aliases|
|--------------|--------|--------|--------------|-------|
|`[PSObject[]]`|false   |3       |true (ByValue)|Input  |

#### **Parameter**
The parameters to pass to the command

|Type          |Required|Position|PipelineInput        |Aliases                                     |
|--------------|--------|--------|---------------------|--------------------------------------------|
|`[PSObject[]]`|false   |4       |true (ByPropertyName)|Parameters<br/>Params<br/>Options<br/>Option|

#### **DataTable**
The datatable object.  This is the in-memory database that will be converted.
To convert multiple tables, pipe in an object with a DataTable property.

|Type         |Required|Position|PipelineInput        |Aliases                        |
|-------------|--------|--------|---------------------|-------------------------------|
|`[DataTable]`|true    |5       |true (ByPropertyName)|Table<br/>Tables<br/>DataTables|

---

### Syntax
```PowerShell
ConvertFrom-PSDataTable [[-To] <PSObject>] [[-ArgumentList] <PSObject[]>] [[-InputObject] <PSObject[]>] [[-Parameter] <PSObject[]>] [-DataTable] <DataTable> [<CommonParameters>]
```
