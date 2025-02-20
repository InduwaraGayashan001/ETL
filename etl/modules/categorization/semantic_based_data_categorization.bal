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
# + dataset - Array of records containing textual data.
# + fieldName - Name of the field to categorize.
# + categories - Array of category names for classification.
# + modelName - Name of the Open AI model
# + return - A nested array of categorized records or an error if classification fails.
function categorizeSemantic(record {}[] dataset, string fieldName, string[] categories, string modelName = "gpt-4o") returns record {}[][]|error {
    do {
        chat:CreateChatCompletionRequest request = {
            model: modelName,
            messages: [
                {
                    "role": "user",
                    "content": string `Classify the given dataset into one of the specified categories based on the provided field name.  
                                        - Input Dataset: ${dataset.toString()}  
                                        - Categories: ${categories.toString()}  
                                        - Field: ${fieldName}  
                                        If a record does not belong to any category, place it in a separate dataset at the end.  
                                        Respond only with an array of arrays of JSON objects without any formatting.  
                                        Do not include any additional text, explanations, or variations. 

                                        Example

                                        - Input Dataset :
                                        [{"order_id":"1","customer_name":"John Doe","comments":"The product quality is excellent and I am very happy!"},
                                         {"order_id":"2","customer_name":"Jane Smith","comments":"It is good. But the delivery was slow."},
                                         {"order_id":"3","customer_name":"Mike Johnson","comments":"Terrible experience. I will never order again."},
                                         {"order_id":"4","customer_name":"Anna Lee","comments":"The customer service was great. But the product was damaged."},
                                         {"order_id":"5","customer_name":"David Brown","comments":"Simply the best! I highly recommend."},
                                         {"order_id":"6","customer_name":"Emily Clark","comments":":);"},
                                         {"order_id":"7","customer_name":"Mark White","comments":"Worst experience ever. Totally disappointed."},
                                         {"order_id":"8","customer_name":"Sophia Green","comments":"Not bad. But could be improved."}]

                                        - Category Names : ["Excellent", "Normal", "Worst"]

                                        - Output Dataset :
                                        [[{"order_id":"1","customer_name":"John Doe","comments":"The product quality is excellent and I am very happy!"},{"order_id":"5","customer_name":"David Brown","comments":"Simply the best! I highly recommend."}],
                                         [{"order_id":"2","customer_name":"Jane Smith","comments":"It is good. But the delivery was slow."},{"order_id":"4","customer_name":"Anna Lee","comments":"The customer service was great. But the product was damaged."},{"order_id":"8","customer_name":"Sophia Green","comments":"Not bad. But could be improved."}],
                                         [{"order_id":"3","customer_name":"Mike Johnson","comments":"Terrible experience. I will never order again."},{"order_id":"7","customer_name":"Mark White","comments":"Worst experience ever. Totally disappointed."}],
                                         [{"order_id":"6","customer_name":"Emily Clark","comments":":);"}]]  `
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
