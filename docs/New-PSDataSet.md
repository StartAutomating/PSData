New-PSDataSet
-------------

### Synopsis
Creates a new DataSet.

---

### Description

Creates a new DataSet object.

DataSets are used to store multiple DataTables, and are used to serialize and deserialize data.

---

### Examples
> EXAMPLE 1

```PowerShell
New-PSDataSet -DataSetName 'MyDataSet'
```

---

### Parameters
#### **DataSetName**
The name of the data set.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **DataSetNamespace**
The namespace of the data set.
This is mainly metadata, and is the XML namespace of the table if it is serialized to XML.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **DataSetPrefix**
The prefix of the data set.
This is used to shorten references to the table if it is serialized to XML.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

---

### Syntax
```PowerShell
New-PSDataSet [[-DataSetName] <String>] [[-DataSetNamespace] <String>] [[-DataSetPrefix] <String>] [<CommonParameters>]
```
