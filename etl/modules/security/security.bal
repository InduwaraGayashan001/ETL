import ballerina/crypto;
import ballerina/data.jsondata;
import ballerina/lang.array;
import ballerinax/openai.chat;

# Encrypts specific fields of a dataset using AES-ECB encryption with a given Base64-encoded key.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 }
# ];
# string[] fieldNames = ["name", "age"];
# string keyBase64 = "aGVsbG9zZWNyZXRrZXkxMjM0NTY=";
# record {}[] encryptedData = check security:encryptData(dataset, fieldNames, keyBase64);
# ```
#
# + dataset - The dataset containing records where specific fields need encryption.
# + fieldNames - An array of field names that should be encrypted.
# + keyBase64 - The AES encryption key in Base64 format.
# + return - A dataset with specified fields encrypted using AES-ECB and Base64-encoded.
public function encryptData(record {}[] dataset, string[] fieldNames, string keyBase64) returns record {}[]|Error {
    if fieldNames.some(fieldName => !dataset[0].hasKey(fieldName)) {
        return error(string `Some fields not found in the dataset`);
    }
    else {
        byte[] encryptkey = check array:fromBase64(keyBase64);
        record {}[] encryptedDataSet = [];
        foreach record {} data in dataset {
            record {} encryptedData = {};
            foreach string key in data.keys() {
                if fieldNames.some(element => element == key) {
                    byte[] dataByte = data[key].toString().toBytes();
                    byte[] cipherText = check crypto:encryptAesEcb(dataByte, encryptkey);
                    encryptedData[key] = cipherText.toBase64();
                } else {
                    encryptedData[key] = data[key];
                }
            }
            encryptedDataSet.push(encryptedData);
        }
        return encryptedDataSet;
    }
}

# Decrypts specific fields of a dataset using AES-ECB decryption with a given Base64-encoded key.
#
# ```ballerina
# record {}[] encryptedDataset = [
#     { "name": "U2FtcGxlTmFtZQ==", "age": "MjU=" },
#     { "name": "Qm9i", "age": "MzA=" }
# ];
# string[] fieldNames = ["name", "age"];
# string keyBase64 = "aGVsbG9zZWNyZXRrZXkxMjM0NTY=";
# record {}[] decryptedData = check security:decryptData(encryptedDataset, fieldNames, keyBase64);
# ```
#
# + dataset - The dataset containing records with Base64-encoded encrypted fields.
# + fieldNames - An array of field names that should be decrypted.
# + keyBase64 - The AES decryption key in Base64 format.
# + return - A dataset with the specified fields decrypted.
public function decryptData(record {}[] dataset, string[] fieldNames, string keyBase64) returns record {}[]|Error {
    if fieldNames.some(fieldName => !dataset[0].hasKey(fieldName)) {
        return error(string `Some fields not found in the dataset`);
    }
    else {
        byte[] decryptKey = check array:fromBase64(keyBase64);
        record {}[] decryptededDataSet = [];
        foreach record {} data in dataset {
            record {} decryptedData = {};
            foreach string key in data.keys() {
                if fieldNames.some(element => element == key) {
                    byte[] dataByte = check array:fromBase64(data[key].toString());
                    byte[] plainText = check crypto:decryptAesEcb(dataByte, decryptKey);
                    string plainTextString = check string:fromBytes(plainText);
                    decryptedData[key] = plainTextString;
                } else {
                    decryptedData[key] = data[key];
                }
            }
            decryptededDataSet.push(decryptedData);
        }
        return decryptededDataSet;
    }
}

# Masks specified fields of a dataset by replacing each character in the sensitive fields with a default masking character.
#
# This function sends a request to the GPT-4 API to identify fields in the dataset that contain Personally Identifiable Information (PII),
# and replaces all characters in those fields with the default masking character 'X'.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "John Doe", "email": "john@example.com" },
#     { "id": 2, "name": "Jane Smith", "email": "jane@example.com" }
# ];
# record {}[] maskedData = check security:maskSensitiveData(dataset);
# ```
#
# + dataset - The dataset containing records where sensitive fields should be masked.
# + modelName - The name of the GPT model to use for identifying PII. Default is "gpt-4o".
# + maskingCharacter - The character to use for masking sensitive fields. Default is 'X'.
# + return - A dataset where the specified fields containing PII are masked with the given masking character.
public function maskSensitiveData(record {}[] dataset, string:Char maskingCharacter = "X", string modelName = "gpt-4o") returns record {}[]|Error {
    do {
        chat:CreateChatCompletionRequest request = {
            model: modelName,
            messages: [
                {
                    "role": "user",
                    "content": string ` Personally Identifiable Information (PII) includes any data that can be used to identify an individual, either on its own or when combined with other information. Examples of PII include:
                                            -Names: Full name, maiden name, alias
                                            -Addresses: Street, email
                                            -Phone numbers: Mobile, personal, business
                                            -Identifiers: SSN, passport number, driver's license
                                            -Biometric data: Fingerprints, retina scan, voice signature
                                            -Asset information: IP address, MAC address
                                            -Personal features: Photographs, x-rays
                                            -Information about owned property: Vehicle registration number
                                            -Other information: Date of birth, place of birth, race, religion, employment, medical, education, financial details
                                        Under GDPR, additional personal data includes online identifiers like IP addresses, cookie IDs, and de-identified data that can be re-identified.
                                        Non-PII includes information that can't identify an individual, such as anonymized data or a company registration number.
                                        Note: All personal data can be PII, but not all PII is personal data under certain legal frameworks like GDPR.
                    
                                        Identify the fields with Personally Identifiable Information (PII) in the following dataset and mask them with the character ${maskingCharacter} with each character replaced.:
                                        - Dataset: ${dataset.toString()}
                                        Return only the masked dataset as an array of json without any formatting .  
                                        Do not include any additional text, explanations, or variations
                                        
                                        Example:
                                        -Input;
                                        [{ "id": 1, "name": "John Doe", "email": "john@example.com" },
                                        { "id": 2, "name": "Jane Smith", "email": "jane@example.com" },
                                        { "id": 3, "name": "Alice", "email": "alice@example.com" }]
                                        -Output:
                                        [{ "id": 1, "name": "XXXX XXX", "email": XXXXXXXXXXXXXXXX" },
                                        { "id": 2, "name": "XXXX XXXXX", "email": XXXXXXXXXXXXXXXX" },
                                        { "id": 3, "name": "XXXXX", "email": XXXXXXXXXXXXXXXXX" }]`
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

