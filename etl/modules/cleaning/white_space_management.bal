# Cleans up whitespace in all fields of a dataset.
# ```ballerina
# record {}[] dataset = [
#     { "name": "  Alice   ", "city": "New   York  " },
#     { "name": "   Bob", "city": "Los  Angeles  " }
# ];
# record {}[] cleanedData = check handleWhiteSpaces(dataset);
# ```
#
# + dataSet - Array of records with possible extra spaces.
# + return - A dataset where multiple spaces are replaced with a single space, and values are trimmed.
public function handleWhiteSpaces(record {}[] dataSet) returns record {}[]|error {
    do {
        foreach record {} data in dataSet {
            foreach string key in data.keys() {
                data[key] = re `\s+`.replaceAll(data[key].toString(), " ").trim();
            }
        }
        return dataSet;
    } on fail error e {
        return e;
    }
}
