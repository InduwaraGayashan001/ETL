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
# + modelName - Name of the Open AI model
# + return - A `DuplicateGroupingResult` containing:
# - `uniqueRecords`: Array of records that have no approximate duplicates.
# - `duplicateGroups`: Groups of approximate duplicate records as an array of arrays.
# Returns an error if the operation fails.
function groupApproximateDuplicates(record {}[] dataset, string modelName = "gpt-4o") returns DuplicateGroupingResult|error {
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
