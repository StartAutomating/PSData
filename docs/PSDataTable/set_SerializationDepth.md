PSDataTable.set_SerializationDepth()
------------------------------------

### Synopsis
Sets the serialization depth

---

### Description

Sets the serialization depth for a DataTable.

This is the -Depth parameter passed to any serializer that is used to serialize the DataTable.

---

### Parameters
#### **Depth**

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |1       |false        |

---

### Notes
By default, this is `$FormatEnumerationLimit + 1`.

---
