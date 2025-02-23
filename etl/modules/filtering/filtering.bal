import ballerina/lang.regexp;
import ballerina/random;

# Splits a dataset into two parts based on a given ratio.
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice" },
#     { "id": 2, "name": "Bob" },
#     { "id": 3, "name": "Charlie" },
#     { "id": 4, "name": "David" }
# ];
# float ratio = 0.75;
# [record {}[], record {}[]] [part1, part2] = check filtering:filterDataByRatio(dataset, ratio);
# ```
#
# + dataset - Array of records to be split.
# + ratio - The ratio for splitting the dataset (e.g., `0.75` means 75% in the first set).
# + return - A tuple containing two subsets of the dataset.
public function filterDataByRatio(record {}[] dataset, float ratio) returns [record {}[], record {}[]]|error {
    do {
        function (record {}[] data) returns record {}[]|error shuffle = function(record {}[] data) returns record {}[]|error {
            int dataLength = data.length();
            foreach int i in 0 ... dataLength - 1 {
                int randomIndex = check random:createIntInRange(i, dataLength);
                record {} temp = data[i];
                data[i] = data[randomIndex];
                data[randomIndex] = temp;
            }
            return data;
        };
        int dataLength = dataset.length();
        int splittingPoint = <int>(dataLength * ratio);
        record {}[] shuffledData = check shuffle(dataset);
        return [shuffledData.slice(0, splittingPoint), shuffledData.slice(splittingPoint)];
    } on fail error e {
        return e;
    }

}

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
# [record {}[], record {}[]] [matched, nonMatched] = check filtering:filterDataByRegex(dataset, fieldName, regexPattern);
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

# Filters a dataset based on a relative numeric comparison expression.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 },
#     { "id": 3, "name": "Charlie", "age": 22 },
#     { "id": 4, "name": "David", "age": 28 }
# ];
# string fieldName = "age";
# string operation = ">";
# float value = 25;
# [record {}[], record {}[]] [olderThan25, youngerOrEqual25] = check filtering:filterDataByRelativeExp(dataset, fieldName, operation, value);
# ```
#
# + dataset - Array of records containing numeric fields for comparison.
# + fieldName - Name of the field to evaluate.
# + operation - Comparison operator (`>`, `<`, `>=`, `<=`, `==`, `!=`). 
# + value - Numeric value to compare against.
# + return - A tuple with two subsets: one that matches the condition and one that does not.
public function filterDataByRelativeExp(record {}[] dataset, string fieldName, Operation operation, float value) returns [record {}[], record {}[]]|error {
    do {
        record {}[] matchedData = [];
        record {}[] nonMatchedData = [];

        function (float fieldValue, float comparisonValue) returns boolean evaluateCondition = function(float fieldValue, float comparisonValue) returns boolean {
            match operation {
                GREATER_THAN => {
                    return fieldValue > value;
                }
                LESS_THAN => {
                    return fieldValue < value;
                }
                GREATER_THAN_OR_EQUAL => {
                    return fieldValue >= value;
                }
                LESS_THAN_OR_EQUAL => {
                    return fieldValue <= value;
                }
                EQUAL => {
                    return fieldValue == value;
                }
                _ => {
                    return fieldValue != value;
                }
            }

        };
        foreach record {} data in dataset {
            float fieldValue = check data[fieldName].ensureType();
            boolean conditionResult = evaluateCondition(fieldValue, value);
            if conditionResult {
                matchedData.push(data);
            } else {
                nonMatchedData.push(data);
            }
        }
        return [matchedData, nonMatchedData];
    } on fail error e {
        return e;
    }
}
