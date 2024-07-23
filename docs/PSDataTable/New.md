PSDataTable.New()
-----------------

### Synopsis
Creates a new table

---

### Description

Creates a new data table.

---

### Parameters
#### **TableName**
The name of the table.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

#### **TableNamespace**
The namespace of the table.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

#### **TablePrefix**
The prefix of the table.
This is used to shorten references to the table if is serialized to XML.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |

#### **Column**
The columns of the table.

|Type          |Required|Position|PipelineInput|Aliases|
|--------------|--------|--------|-------------|-------|
|`[PSObject[]]`|false   |4       |false        |Columns|

#### **Key**
The names of key(s) of the table.  Providing multiple keys will create a composite key.
Keys are not required for in-memory tables (though they are still very useful)

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |5       |false        |

#### **Row**
The rows of the table.

|Type          |Required|Position|PipelineInput                 |Aliases|
|--------------|--------|--------|------------------------------|-------|
|`[PSObject[]]`|false   |6       |true (ByValue, ByPropertyName)|Rows   |

---
