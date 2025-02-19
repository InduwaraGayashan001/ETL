import ballerina/lang.regexp;

# Categorizes a dataset based on a string field using a set of regular expressions.
# ```ballerina
# import ballerina/regexp;
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Colombo" },
#     { "name": "John", "city": "Boston" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# string fieldName = "name";
# regexp:RegExp[] regexArray = [re `A.*$`, re `^B.*$`, re `^C.*$`];
# record {}[][] categorized = check categorizeRegexData(dataset, fieldName, regexArray);
# ```
#
# + dataset - Array of records containing string values.
# + fieldName - Name of the string field to categorize.
# + regexArray - Array of regular expressions for matching categories.
# + return - A nested array of categorized records or an error if categorization fails.
public function categorizeRegexData(record {}[] dataset, string fieldName, regexp:RegExp[] regexArray) returns record {}[][]|error {
    do {
        record {}[][] categorizedData = [];
        foreach int i in 0 ... regexArray.length() {
            categorizedData.push([]);
        }
        foreach record {} data in dataset {
            boolean isCategorized = false;
            foreach regexp:RegExp regex in regexArray {
                if regex.isFullMatch((data[fieldName].toString())) {
                    categorizedData[check regexArray.indexOf(regex).ensureType(int)].push(data);
                    isCategorized = true;
                    break;
                }
            }
            if (!isCategorized) {
                categorizedData[regexArray.length()].push(data);
            }
        }
        return categorizedData;
    } on fail error e {
        return e;
    }
}
