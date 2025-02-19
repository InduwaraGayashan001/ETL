import ballerina/regex;
import ballerinax/openai.chat;

# Removes approximate duplicates from a dataset, keeping only the first occurrence of each duplicate record.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "New York" },
#     { "name": "Alice", "city": "new york" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# record {}[] uniqueData = check removeApproximateDuplicates(dataset);
# ```
#
# + dataSet - Array of records containing data that may have approximate duplicates.
# + return - A dataset with approximate duplicates removed, keeping only the first occurrence of each duplicate record.
public function removeApproximateDuplicates(record {}[] dataSet) returns record {}[]|error {
    do {
        chat:CreateChatCompletionRequest request = {
            model: "gpt-4o",
            messages: [
                {
                    "role": "user",
                    "content": string `Identify approximate duplicates in the dataset.
                                        - Input Dataset : ${dataSet.toString()}  
                                        Respond strictly with a plain string array (not JSON) where each record is labeled as 'unique' or 'duplicate'. 
                                        Mark the first occurrence of any duplicate as 'unique'.  
                                        Do not include any additional text, explanations, or variations.`
                }
            ]
        };

        chat:CreateChatCompletionResponse response = check chatClient->/chat/completions.post(request);
        string content = check response.choices[0].message?.content.ensureType();
        string[] contentArray = re `,`.split(regex:replaceAll(content, "\"|'|\\[|\\]", "")).'map(element => element.trim()); //todo

        return from record {} data in dataSet
            where contentArray[<int>dataSet.indexOf(data)] is "unique"
            select data;
    } on fail error e {
        return e;
    }
}
//return two datasets
//try to use an  util.bal in order to prevent repetition
