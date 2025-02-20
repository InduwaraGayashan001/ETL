# Cleans up whitespace in all fields of a dataset.
# ```ballerina
# record {}[] dataset = [
#     { "name": "  Alice   ", "city": "New   York  " },
#     { "name": "   Bob", "city": "Los  Angeles  " }
# ];
# record {}[] cleanedData = check handleWhiteSpaces(dataset);
# ```
#
# + dataset - Array of records with possible extra spaces.
# + return - A dataset where multiple spaces are replaced with a single space, and values are trimmed.
public function handleWhiteSpaces(record {}[] dataset) returns record {}[]|error {
    do {
        from record {} data in dataset
        from string key in data.keys()
        do {
            data[key] = re `\s+`.replaceAll(data[key].toString(), " ").trim();
        };
        return dataset;
    } on fail error e {
        return e;
    }
}
