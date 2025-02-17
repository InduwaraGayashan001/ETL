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
            foreach string key in data.keys() {
                if data[key] is null || data[key].toString().trim() == "" {
                    containNull = true;
                    break;
                }
            }
            return containNull;
        };
        return from record {} data in dataSet
            where !isContainNull(data)
            select data;
    } on fail error e {
        return e;
    }

}
