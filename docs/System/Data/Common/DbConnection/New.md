System.Data.Common.DbConnection.New()
-------------------------------------

### Synopsis
Creates a new connection to a data source

---

### Description

Creates a new connection to a data source (usually a database).

By default, this tries to use the `System.Data.SqlClient.SqlConnection` type.

An alternate typename can be specified by providing the `-ConnectionTypeName` parameter.

---

### Parameters
#### **ConnectionSecret**
The connection secret (or connection string, if you are brave).
If a secret is provided, it will be used to retrieve the connection string.
This will require the Microsoft.PowerShell.SecretManagement module.

|Type      |Required|Position|PipelineInput        |Aliases                                      |
|----------|--------|--------|---------------------|---------------------------------------------|
|`[String]`|false   |1       |true (ByPropertyName)|ConnectionString<br/>ConnectionStringOrSecret|

#### **VaultName**
The name of the vault to use to retrieve the connection secret.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **ConnectionTypeName**
The type name of connection type.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **AssemblyLocation**
The assembly location of the data adapter to use.

|Type      |Required|Position|PipelineInput        |Aliases     |
|----------|--------|--------|---------------------|------------|
|`[String]`|false   |4       |true (ByPropertyName)|AssemblyPath|

---
