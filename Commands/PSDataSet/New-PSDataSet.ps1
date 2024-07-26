function New-PSDataSet {
    <#
    .SYNOPSIS
        Creates a new DataSet.
    .DESCRIPTION
        Creates a new DataSet object.

        DataSets are used to store multiple DataTables, and are used to serialize and deserialize data.
    .EXAMPLE
        New-PSDataSet -DataSetName 'MyDataSet'
    #>
    [Alias('New-DataSet')]
    param(
    # The name of the data set.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DataSetName,

    # The namespace of the data set.
    # This is mainly metadata, and is the XML namespace of the table if it is serialized to XML.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DataSetNamespace,

    # The prefix of the data set.
    # This is used to shorten references to the table if it is serialized to XML.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DataSetPrefix
    )

    process {
        # Create the DataSet
        $newDataSet = [Data.DataSet]::new()
        # If we have a name, set it.
        if ($DataSetName) {
            $newDataSet.DataSetName = $DataSetName
        }
        # If we have a namespace, set it.
        if ($DataSetNamespace) {
            $newDataSet.Namespace = $DataSetNamespace
        }
        # If we have a prefix, set it.
        if ($DataSetPrefix) {
            $newDataSet.Prefix = $DataSetPrefix
        }
        # Return the new DataSet.
        return $newDataSet
    }    
}