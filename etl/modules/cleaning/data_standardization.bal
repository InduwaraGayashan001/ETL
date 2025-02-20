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
