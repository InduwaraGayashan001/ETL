public enum Operation {
    GREATER_THAN = ">",
    LESS_THAN = "<",
    EQUAL = "==",
    NOT_EQUAL = "!=",
    GREATER_THAN_OR_EQUAL = ">=",
    LESS_THAN_OR_EQUAL = "<="

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
# [record {}[], record {}[]] [olderThan25, youngerOrEqual25] = check filterDataByRelativeExp(dataset, fieldName, operation, value);
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
