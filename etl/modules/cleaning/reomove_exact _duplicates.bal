# Removes duplicate records from the dataset based on their exact content.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Los Angeles" },
#     { "name": "Alice", "city": "New York" }
# ];
# record {}[] uniqueData = check removeDuplicates(dataset);
# ```
#
# + dataSet - Array of records that may contain duplicates.
# + return - A dataset with duplicates removed.
public function removeDuplicates(record {}[] dataSet) returns record {}[]|error {
    do {
        return from var data in dataSet
            group by data
            select data;
    } on fail error e {
        return e;
    }
}
