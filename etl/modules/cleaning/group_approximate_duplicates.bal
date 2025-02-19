import ballerina/data.jsondata;
import ballerinax/openai.chat;

type DuplicateGroupingResult record {
    record {}[] uniqueRecords;
    record {}[][] duplicateGroups;
};

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
# + return - A `DuplicateGroupingResult` containing:
# - `uniqueRecords`: Array of records that have no approximate duplicates.
# - `duplicateGroups`: Groups of approximate duplicate records as an array of arrays.
# Returns an error if the operation fails.
function groupApproximateDuplicates(record {}[] dataset) returns DuplicateGroupingResult|error {
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
                    "content": string `Identify and group approximate duplicates in the given dataset.  
                                - Input Dataset: ${dataset.toJsonString()}  
                                Return a JSON object with the following structure without any formatting, without any additional text, explanations, or variations:  

                                {
                                    "uniqueRecords": [
                                        // Array of unique records that do not have any duplicates.
                                        // If no unique records exist, return an empty array.
                                    ],
                                    "duplicateGroups": [
                                        // An array of groups where each group contains records that are approximate duplicates of each other.
                                    ]
                                }`
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
