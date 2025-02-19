# Removes records that contain null or empty string values in any field.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": null },
#     { "name": "Charlie", "city": "" }
# ];
# record {}[] filteredData = check removeNull(dataset);
# ```
#
# + dataSet - Array of records containing potential null or empty fields.
# + return - A dataset with records containing null or empty string values removed.
public function removeNull(record {}[] dataSet) returns record {}[]|error {
    do {
        function (record {} data) returns boolean isContainNull = function(record {} data) returns boolean {
            boolean containNull = false;
            from string key in data.keys()
            where data[key] is null || data[key].toString().trim() == ""
            do {
                containNull = true;
            };
            return containNull;
        };
        return from record {} data in dataSet
            where !isContainNull(data)
            select data;
    } on fail error e {
        return e;
    }
}
