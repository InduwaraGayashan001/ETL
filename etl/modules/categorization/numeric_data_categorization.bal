# Categorizes a dataset based on a numeric field and specified ranges.
# ```ballerina
# record {}[] dataset = [{value: 10.5}, {value: 25.0}, {value: 5.3}];
# string fieldName = "value";
# float[][] rangeArray = [[0.0, 10.0], [10.0, 20.0]];
# record {}[][] categorized = check categorizeNumeric(dataset, fieldName, rangeArray);
# ```
#
# + dataset - Array of records containing numeric values.
# + fieldName - Name of the numeric field to categorize.
# + rangeArray - Array of float ranges specifying category boundaries.
# + return - A nested array of categorized records or an error if categorization fails.
public function categorizeNumeric(record {}[] dataset, string fieldName, float[][] rangeArray) returns record {}[][]|error {
    do {
        record {}[][] categorizedData = [];
        foreach int i in 0 ... rangeArray.length() {
            categorizedData.push([]);
        }
        foreach record {} data in dataset {
            float fieldValue = <float>data[fieldName];
            boolean isCategorized = false;
            foreach float[] range in rangeArray {
                if (fieldValue >= range[0] && fieldValue < range[1]) {
                    categorizedData[<int>rangeArray.indexOf(range)].push(data);
                    isCategorized = true;
                    break;
                }
            }
            if (!isCategorized) {
                categorizedData[rangeArray.length()].push(data);
            }
        }
        return categorizedData;
    } on fail error e {
        return e;
    }
}
