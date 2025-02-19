import ballerina/data.jsondata;
import ballerinax/openai.chat;

configurable string openAIKey = ?;

final chat:Client chatClient = check new ({ //todo
    auth: {
        token: openAIKey
    }
});

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
# + return - An updated dataset with standardized string values or an error if the operation fails.
function standardizeData(record {}[] dataset, string fieldName, string searchValue) returns record {}[]|error {
    do {

        chat:CreateChatCompletionRequest request = {
            model: "gpt-4o",
            messages: [
                {
                    "role": "user",
                    "content": string ` Identify and replace any approximate matches of the given search value in the dataset with the standard value.  
                                        - Input Dataset: ${dataset.toString()}  
                                        - Field Name: ${fieldName}  
                                        - Search Value: ${searchValue}  
                                        Return only the standardized dataset as an array of JSON objects without any formatting .  
                                        Do not include any additional text, explanations, or variations.`
                }
            ]
        };

        chat:CreateChatCompletionResponse result = check chatClient->/chat/completions.post(request);
        string content = check result.choices[0].message?.content.ensureType();
        record {}[] newDataset = check jsondata:parseAsType(check content.fromJsonString());
        return newDataset;
    } on fail error e {
        return e;
    }
}
