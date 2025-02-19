import ballerina/lang.regexp;

# Replaces text in a specific field of a dataset using regular expressions.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Los Angeles" },
#     { "name": "Charlie", "city": "Chicago" }
# ];
# string fieldName = "city";
# regexp:RegExp searchValue = re `New York`;
# string replaceValue = "San Francisco";
# record {}[] updatedData = check replaceText(dataset, fieldName, searchValue, replaceValue);
# ```
#
# + dataSet - Array of records where text in a specified field will be replaced.
# + fieldName - The name of the field where text replacement will occur.
# + searchValue - A regular expression to match text that will be replaced.
# + replaceValue - The value that will replace the matched text.
# + return - A new dataset with the replaced text in the specified field.
public function replaceText(record {}[] dataSet, string fieldName, regexp:RegExp searchValue, string replaceValue) returns record {}[]|error {
    do {
        from record {} data in dataSet
        let string newData = searchValue.replace(data[fieldName].toString(), replaceValue)
        do {
            data[fieldName] = newData;
        };
        return dataSet;
    } on fail error e {
        return e;
    }
}
