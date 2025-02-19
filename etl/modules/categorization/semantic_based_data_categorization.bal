import ballerina/data.jsondata;
import ballerinax/openai.chat;

configurable string openAIKey = ?;

final chat:Client chatClient = check new ({
    auth: {
        token: openAIKey
    }
});

# Categorizes a dataset based on a string field using semantic classification via OpenAI's GPT model.
# ```ballerina
# record {}[] dataset = [
#     {"id": 1, "comment": "Great service!"},
#     {"id": 2, "comment": "Terrible experience"}
# ];
# string fieldName = "comment";
# string[] categories = ["Positive", "Negative"];
# record {}[][] categorized = check categorizeSemantic(dataset, fieldName, categories);
# ```
#
# + dataSet - Array of records containing textual data.
# + fieldName - Name of the field to categorize.
# + categories - Array of category names for classification.
# + return - A nested array of categorized records or an error if classification fails.
public function categorizeSemantic(record {}[] dataSet, string fieldName, string[] categories) returns record {}[][]|error {
    do {
        chat:CreateChatCompletionRequest request = {
            model: "gpt-4o",
            messages: [
                {
                    "role": "user",
                    "content": string `Classify the given dataset into one of the specified categories based on the provided field name.  
                                        - Input Dataset: ${dataSet.toString()}  
                                        - Categories: ${categories.toString()}  
                                        - Field: ${fieldName}  
                                        If a record does not belong to any category, place it in a separate dataset at the end.  
                                        Respond only with an array of arrays of JSON objects without any formatting.  
                                        Do not include any additional text, explanations, or variations.  `
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
