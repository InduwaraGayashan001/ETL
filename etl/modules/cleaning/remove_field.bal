# Removes a specified field from each record in the dataset.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York", "age": 30 },
#     { "name": "Bob", "city": "Los Angeles", "age": 25 },
#     { "name": "Charlie", "city": "Chicago", "age": 35 }
# ];
# string fieldName = "age";
# record {}[] updatedData = check removeField(dataset, fieldName);
# ```
#
# + dataSet - Array of records with fields to be removed.
# + fieldName - The name of the field to remove from each record.
# + return - A new dataset with the specified field removed from each record.
public function removeField(record {}[] dataSet, string fieldName) returns record {}[]|error {
    do {
        return from record {} data in dataSet
            let var val = data.remove(fieldName)
            where val != ()
            select data;
    } on fail error e {
        return e;
    }
}
