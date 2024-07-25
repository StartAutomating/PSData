System.Data.DataTable.To.XML()
------------------------------

### Synopsis
Gets a DataTable as XML

---

### Description

Gets a DataTable as XML, using the `WriteXml` method.

---

### Notes
This property will only return the XML representation of simple DataTables, whose columns are all of simple types.

If this errors out, because it is a property it will simply return nothing.

To examine the errors, look at `$Error`.

---
