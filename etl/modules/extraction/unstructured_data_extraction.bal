import ballerina/data.jsondata;
import ballerinax/openai.chat;

configurable string openAIKey = ?;

final chat:Client chatClient = check new ({ //todo
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
# + dataSet - Array of unstructured string data (e.g., reviews or comments).
# + fieldNames - Array of field names to map the extracted details.
# + return - A record with extracted details mapped to the specified field names or an error if extraction fails.
public function extractUnstructuredData(string dataSet, string[] fieldNames) returns record {}|error {
    do {

        chat:CreateChatCompletionRequest request = {
            model: "gpt-4o",
            messages: [
                {
                    "role": "user",
                    "content": string `Extract relevant details from the given string array and map them to the specified fields. 
                                    - Input Data : ${dataSet.toString()} 
                                    - Fields to extract: ${fieldNames.toString()}
                                    Respond with a JSON object without any formatting.
                                    Do not include field names or any additional text, explanations, or variations.`
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
