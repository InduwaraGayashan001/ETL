import ballerina/data.jsondata;
import ballerinax/openai.chat;

configurable string openAIKey = ?;

final chat:Client chatClient = check new ({
    auth: {
        token: openAIKey
    }
});

# Extracts unstructured data from a string array and maps it to the specified fields.
# ```ballerina
# string[] reviews = ["The product is great, but it could be improved.", "Not bad, but needs some updates."];
# string[] fields = ["goodPoints", "badPoints", "improvements"];
# record {} extractedDetails = check extractUnstructuredData(reviews, fields);
# ```
#
# + dataset - Array of unstructured string data (e.g., reviews or comments).
# + fieldNames - Array of field names to map the extracted details.
# + modelName - Name of the Open AI model
# + return - A record with extracted details mapped to the specified field names or an error if extraction fails.
function extractUnstructuredData(string dataset, string[] fieldNames, string modelName = "gpt-4o") returns record {}|error {
    do {

        chat:CreateChatCompletionRequest request = {
            model: "gpt-4o",
            messages: [
                {
                    "role": "user",
                    "content": string ` Extract relevant details from the given string array and map them to the specified fields. 
                                        - Input Data : ${dataset.toString()} 
                                        - Fields to extract: ${fieldNames.toString()}
                                        Respond with a JSON object without any formatting.
                                        Do not include field names or any additional text, explanations, or variations.
                                        
                                        Example

                                        - Input Data :
                                        "The smartphone has an impressive camera and smooth performance, making it great for photography and gaming.
                                        However, the battery drains quickly, and the charging speed could be improved.
                                        The UI is intuitive, but some features feel outdated and need a refresh."
                                        
                                        - Fields to extract : ["goodPoints", "badPoints", "improvements"]

                                        - Output Result :
                                        {
                                            "goodPoints":["impressive camera","smooth performance","great for photography","great for gaming","UI is intuitive"],
                                            "badPoints":["battery drains quickly","some features feel outdated"],
                                            "improvements":["charging speed could be improved","features need a refresh"]
                                        } `
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
