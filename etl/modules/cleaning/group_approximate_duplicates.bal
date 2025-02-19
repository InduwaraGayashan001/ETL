import ballerinax/openai.chat;
import ballerina/data.jsondata;

# Groups approximate duplicates from a dataset, returning an array of grouped records.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "New York" },
#     { "name": "Alice", "city": "new york" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# record {}[][] similarData = check groupApproximateDuplicates(dataset);
# ```
# 
# + dataset - Array of records containing data that may have approximate duplicates.
# + return - A dataset grouped by approximate duplicates, represented as an array of arrays of records or an error if the operation fails.
function groupApproximateDuplicates(record {}[] dataset) returns record{}[][]|error {
    do {
        chat:Client chatClient = check new ({
            auth: {
                token: openAIKey
            }
        });

        chat:CreateChatCompletionRequest request = {
            model: "gpt-4o",
            messages: [
                {
                    "role": "user",
                    "content": string `Group approximate duplicates in the given dataset, ensuring each group contains at least two records. 
                                        - Input Dataset : ${dataset.toString()}  
                                         Respond only with the grouped dataset as an array of arrays of JSON objects, without any formatting.
                                         Do not include any additional text, explanations, or variations.`
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