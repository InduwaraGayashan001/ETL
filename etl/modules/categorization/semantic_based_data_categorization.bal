import ballerina/regex;
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
        string[] valueArray = from record {} data in dataSet
            select data[fieldName].toString();

        chat:CreateChatCompletionRequest request = {
            model: "gpt-4o",
            messages: [
                {
                    "role": "user",
                    "content": string `Classify each text in the array into one of the given category names.
                                        - Data array : ${valueArray.toString()} 
                                        - Category Names : ${categories.toString()}
                                        Respond only the results as an array of category names corresponding to each text.
                                        If a text does not match any of the provided categories, give the category name as 'Other' in the array.`
                }
            ]
        };

        chat:CreateChatCompletionResponse result = check chatClient->/chat/completions.post(request);
        string content = check result.choices[0].message?.content.ensureType();
        string[] contentArray = re `,`.split(regex:replaceAll(content, "\"|'|\\[|\\]", "")).'map(element => element.trim()); //todo - jsonData

        record {}[][] categorizedData = [];
        foreach int i in 0 ... categories.length() {
            categorizedData.push([]);
        }

        foreach int i in 0 ... dataSet.length() - 1 {
            boolean isCategorized = false;
            foreach string category in categories {
                if (category.equalsIgnoreCaseAscii(contentArray[i])) {
                    categorizedData[<int>categories.indexOf(category)].push(dataSet[i]);
                    isCategorized = true;
                    break;
                }
            }
            if (!isCategorized) {
                categorizedData[categories.length()].push(dataSet[i]);
            }
        }
        return categorizedData;
    } on fail error e {
        return e;
    }
}
