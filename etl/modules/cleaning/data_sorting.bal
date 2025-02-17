# Sorts a dataset based on a specific field in ascending or descending order.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "age": 25 },
#     { "name": "Bob", "age": 30 },
#     { "name": "Charlie", "age": 22 }
# ];
# string fieldName = "age";
# boolean isAscending = true;
# record {}[] sortedData = check sort(dataset, fieldName, isAscending);
# ```
#
# + dataSet - Array of records to be sorted.
# + fieldName - The field by which sorting is performed.
# + isAscending - Boolean flag to determine sorting order (default: ascending).
# + return - A sorted dataset based on the specified field.
public function sort(record {}[] dataSet, string fieldName, boolean isAscending = true) returns record {}[]|error {
    do {
        if isAscending {
            return from record {} data in dataSet
                order by data[fieldName].toString() ascending
                select data;
        }
        else {
            return from record {} data in dataSet
                order by data[fieldName].toString() descending
                select data;
        }
    } on fail error e {
        return e;
    }
}
