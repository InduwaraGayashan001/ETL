
# Masks specific fields of a dataset by replacing each character with a specified masking character.
#
# This function iterates through the dataset and replaces all characters (including spaces) in the specified fields
# with the given masking character.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "John Doe", "email": "john@example.com" },
#     { "id": 2, "name": "Jane Smith", "email": "jane@example.com" }
# ];
# string[] fieldNames = ["name", "email"];
# string:Char maskingCharacter = "X";
# record {}[] maskedData = check maskSensitiveData(dataset, fieldNames, maskingCharacter);
# ```
#
# + dataSet - The dataset containing records where sensitive fields should be masked.
# + fieldNames - An array of field names that should be masked.
# + maskingCharacter - The character used to replace each character in the sensitive fields.
# + return - A dataset where the specified fields are masked.
public function maskSensitiveData(record {}[] dataSet, string[] fieldNames, string:Char maskingCharacter) returns record {}[]|error {
    do {
        record {}[] maskedDataset = [];
        foreach record {} data in dataSet {
            record {} maskedData = {};
            foreach string key in data.keys() {
                if fieldNames.some(element => element == key) {
                    maskedData[key] = re `\S|\s`.replaceAll(data[key].toString(), maskingCharacter);
                } else {
                    maskedData[key] = data[key];
                }
            }
            maskedDataset.push(maskedData);
        }
        return maskedDataset;
    } on fail error e {
        return e;
    }
}
