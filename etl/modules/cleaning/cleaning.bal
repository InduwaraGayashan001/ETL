import ballerina/data.jsondata;
import ballerina/lang.regexp;
import ballerinax/openai.chat;

# Sorts a dataset based on a specific field in ascending or descending order.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "age": 25 },
#     { "name": "Bob", "age": 30 },
#     { "name": "Charlie", "age": 22 }
# ];
# string fieldName = "age";
# boolean isAscending = true;
# record {}[] sortedData = check sort(dataset, fieldName, isAscending);
# ```
#
# + dataset - Array of records to be sorted.
# + fieldName - The field by which sorting is performed.
# + isAscending - Boolean flag to determine sorting order (default: ascending).
# + return - A sorted dataset based on the specified field.
public function sort(record {}[] dataset, string fieldName, boolean isAscending = true) returns record {}[]|error {
    do {
        if isAscending {
            return from record {} data in dataset
                order by data[fieldName].toString() ascending
                select data;
        }
        else {
            return from record {} data in dataset
                order by data[fieldName].toString() descending
                select data;
        }
    } on fail error e {
        return e;
    }
}

# Standardizes a dataset by replacing approximate matches in a string field with a specified search value.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "newyork-usa" },
#     { "name": "John", "city": "new york" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# string fieldName = "city";
# string searchValue = "New York";
# record {}[] standardizedData = check standardizeData(dataset, fieldName, searchValue);
# ```
#
# + dataset - Array of records containing string values to be standardized.
# + fieldName - Name of the string field to check for approximate matches.
# + searchValue - The exact value to replace approximate matches.
# + modelName - Name of the Open AI model
# + return - An updated dataset with standardized string values or an error if the operation fails.
public function standardizeData(record {}[] dataset, string fieldName, string searchValue, string modelName = "gpt-4o") returns record {}[]|error {
    do {
        chat:CreateChatCompletionRequest request = {
            model: modelName,
            messages: [
                {
                    "role": "user",
                    "content": string ` Identify and replace any approximate matches of the given search value in the dataset with the standard value.  
                                        - Input Dataset: ${dataset.toString()}  
                                        - Field Name: ${fieldName}  
                                        - Search Value: ${searchValue}  
                                        Return only the standardized dataset as an array of json without any formatting .  
                                        Do not include any additional text, explanations, or variations.
                                        
                                        Example
                                        
                                        - Input Dataset: 
                                        [{"name":"John","city":"Austin","phone":"(555) 555-7873","age":18},
                                         {"name":"Nick","city":"New York","phone":"(555) 555-8823","age":25},
                                         {"name":"Paul","city":"Sydney","phone":"(555) 555-9032","age":35},
                                         {"name":"Jo","city":"Austin","phone":"(555) 555-9120","age":45},
                                         {"name":"Larry","city":"new-york-America","phone":"(555) 555-3022","age":23},
                                         {"name":"James","city":"Portland","phone":"(555) 555-3299","age":23},
                                         {"name":"Smith","city":"newyork-usa","phone":"(555) 555-2313","age":17},
                                         {"name":"Rob","city":"new-yorK","phone":"(555) 555-3124","age":90},
                                         {"name":"Kate","city":"Dallas","phone":"(555) 555-3214","age":40},
                                         {"name":"Tim","city":"Miami","phone":"(555) 555-3123","age":50}]

                                         - Standard Value : "New York"
                                         - Field NAme : "city"

                                         - Output Dataset:
                                         [{"name":"John","city":"Austin","phone":"(555) 555-7873","age":18},
                                          {"name":"Nick","city":"New York","phone":"(555) 555-8823","age":25},
                                          {"name":"Paul","city":"Sydney","phone":"(555) 555-9032","age":35},
                                          {"name":"Jo","city":"Austin","phone":"(555) 555-9120","age":45},
                                          {"name":"Larry","city":"New York","phone":"(555) 555-3022","age":23},
                                          {"name":"James","city":"Portland","phone":"(555) 555-3299","age":23},
                                          {"name":"Smith","city":"New York","phone":"(555) 555-2313","age":17},
                                          {"name":"Rob","city":"New York","phone":"(555) 555-3124","age":90},
                                          {"name":"Kate","city":"Dallas","phone":"(555) 555-3214","age":40},
                                          {"name":"Tim","city":"Miami","phone":"(555) 555-3123","age":50}]
                                        `
                }
            ]
        };

        chat:CreateChatCompletionResponse result = check chatClient->/chat/completions.post(request);
        string content = check result.choices[0].message?.content.ensureType();
        return check jsondata:parseAsType(check content.fromJsonString());
    } on fail error e {
        return e;
    }
}

# Identifies approximate duplicates in a dataset and groups them, returning unique records separately.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "New York" },
#     { "name": "Alice", "city": "new york" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# DuplicateGroupingResult result = check identifyAndGroupDuplicates(dataset);
# ```
#
# + dataset - Array of records that may contain approximate duplicates.
# + modelName - Name of the Open AI model
# + return - A `DuplicateGroupingResult` containing:
# - `uniqueRecords`: Array of records that have no approximate duplicates.
# - `duplicateGroups`: Groups of approximate duplicate records as an array of arrays.
# Returns an error if the operation fails.
public function groupApproximateDuplicates(record {}[] dataset, string modelName = "gpt-4o") returns DuplicateGroupingResult|error {
    do {
        chat:CreateChatCompletionRequest request = {
            model: modelName,
            messages: [
                {
                    "role": "user",
                    "content": string ` Identify approximate duplicates in the dataset and group them.
                                        - Input Dataset : ${dataset.toString()}  
                                         Respond the result as a JSON objects as follows, without any formatting.
                                         {
                                            "uniqueRecords" : This field must contain only the unique records as an array of json objects. If there are no any unique records keep this as empty array
                                            "duplicateGroups" : This field contains all the duplicate groups as an array of array of json objects
                                         }
                                         Do not include any additional text, explanations, or variations.
                                         
                                         Example

                                         - Input Dataset :
                                         [{"customerId":"1","customerName":"John Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main St"},
                                          {"customerId":"2","customerName":"Jon Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main Street"},
                                          {"customerId":"3","customerName":"Jane Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm St"},
                                          {"customerId":"4","customerName":"Janet Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm Street"},
                                          {"customerId":"7","customerName":"Emilly Clark","email":"emily.clark@email.com","phone":"2223334444","address":"101 Pine Street"},
                                          {"customerId":"8","customerName":"John Charles","email":"john.charles@email.com","phone":"3483845456","address":"108 Rose Street"}]

                                        - Output Result :
                                        {
                                            "uniqueRecords":[{"customerId":"5","customerName":"Mark Johnson","email":"mark.j@email.com","phone":"1112223333","address":"789 Oak St"},{"customerId":"8","customerName":"John Charles","email":"john.charles@email.com","phone":"3483845456","address":"108 Rose Street"}],
                                            "duplicateGroups":[[{"customerId":"1","customerName":"John Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main St"},{"customerId":"2","customerName":"Jon Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main Street"}],[{"customerId":"3","customerName":"Jane Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm St"},{"customerId":"4","customerName":"Janet Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm Street"}]
                                        } `
                }
            ]
        };

        chat:CreateChatCompletionResponse response = check chatClient->/chat/completions.post(request);
        string content = check response.choices[0].message?.content.ensureType();
        return check jsondata:parseAsType(check content.fromJsonString());

    } on fail error e {
        return e;
    }
}

# Removes a specified field from each record in the dataset.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York", "age": 30 },
#     { "name": "Bob", "city": "Los Angeles", "age": 25 },
#     { "name": "Charlie", "city": "Chicago", "age": 35 }
# ];
# string fieldName = "age";
# record {}[] updatedData = check removeField(dataset, fieldName);
# ```
#
# + dataSet - Array of records with fields to be removed.
# + fieldName - The name of the field to remove from each record.
# + return - A new dataset with the specified field removed from each record.
public function removeField(record {}[] dataSet, string fieldName) returns record {}[]|error {
    do {
        return from record {} data in dataSet
            let var val = data.remove(fieldName)
            where val != ()
            select data;
    } on fail error e {
        return e;
    }
}

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
# + dataset - Array of records containing potential null or empty fields.
# + return - A dataset with records containing null or empty string values removed.
public function removeNull(record {}[] dataset) returns record {}[]|error {
    do {
        function (record {} data) returns boolean isContainNull = function(record {} data) returns boolean {
            boolean containNull = false;
            from string key in data.keys()
            where data[key] is null || data[key].toString().trim() == ""
            do {
                containNull = true;
            };
            return containNull;
        };
        return from record {} data in dataset
            where !isContainNull(data)
            select data;
    } on fail error e {
        return e;
    }
}

# Removes duplicate records from the dataset based on their exact content.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Los Angeles" },
#     { "name": "Alice", "city": "New York" }
# ];
# record {}[] uniqueData = check removeDuplicates(dataset);
# ```
#
# + dataset - Array of records that may contain duplicates.
# + return - A dataset with duplicates removed.
public function removeDuplicates(record {}[] dataset) returns record {}[]|error {
    do {
        return from var data in dataset
            group by data
            select data;
    } on fail error e {
        return e;
    }
}

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
# + dataset - Array of records where text in a specified field will be replaced.
# + fieldName - The name of the field where text replacement will occur.
# + searchValue - A regular expression to match text that will be replaced.
# + replaceValue - The value that will replace the matched text.
# + return - A new dataset with the replaced text in the specified field.
public function replaceText(record {}[] dataset, string fieldName, regexp:RegExp searchValue, string replaceValue) returns record {}[]|error {
    do {
        from record {} data in dataset
        let string newData = searchValue.replace(data[fieldName].toString(), replaceValue)
        do {
            data[fieldName] = newData;
        };
        return dataset;
    } on fail error e {
        return e;
    }
}

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
        where data[key] is string
        do {
            data[key] = re `\s+`.replaceAll(data[key].toString(), " ").trim();
        };
        return dataset;
    } on fail error e {
        return e;
    }
}
