import ballerina/lang.regexp;

# Filters a dataset into two subsets based on a regex pattern match.
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "city": "New York" },
#     { "id": 2, "city": "Los Angeles" },
#     { "id": 3, "city": "Newark" },
#     { "id": 4, "city": "San Francisco" }
# ];
# string fieldName = "city";
# regexp:RegExp regexPattern = re `^New.*$`;
# [record {}[], record {}[]] [matched, nonMatched] = check filterDataByRegex(dataset, fieldName, regexPattern);
# ```
#
# + dataset - Array of records to be filtered.
# + fieldName - Name of the field to apply the regex filter.
# + regexPattern - Regular expression to match values in the field.
# + return - A tuple with two subsets: matched and non-matched records.
public function filterDataByRegex(record {}[] dataset, string fieldName, regexp:RegExp regexPattern) returns [record {}[], record {}[]]|error {
    do {
        record {}[] matchedData = from record {} data in dataset
            where regexPattern.isFullMatch((data[fieldName].toString()))
            select data;
        record {}[] nonMatchedData = from record {} data in dataset
            where !regexPattern.isFullMatch((data[fieldName].toString()))
            select data;
        return [matchedData, nonMatchedData];
    } on fail error e {
        return e;
    }
}
