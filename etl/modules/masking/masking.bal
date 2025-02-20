import ballerina/crypto;
import ballerina/lang.array;

# Encrypts specific fields of a dataset using AES-ECB encryption with a given Base64-encoded key.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 }
# ];
# string[] fieldNames = ["name", "age"];
# string keyBase64 = "aGVsbG9zZWNyZXRrZXkxMjM0NTY=";
# record {}[] encryptedData = check encryptData(dataset, fieldNames, keyBase64);
# ```
#
# + dataset - The dataset containing records where specific fields need encryption.
# + fieldNames - An array of field names that should be encrypted.
# + keyBase64 - The AES encryption key in Base64 format.
# + return - A dataset with specified fields encrypted using AES-ECB and Base64-encoded.
public function encryptData(record {}[] dataset, string[] fieldNames, string keyBase64) returns record {}[]|error {
    do {
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
    } on fail error e {
        return e;
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
# record {}[] decryptedData = check decryptData(encryptedDataset, fieldNames, keyBase64);
# ```
#
# + dataset - The dataset containing records with Base64-encoded encrypted fields.
# + fieldNames - An array of field names that should be decrypted.
# + keyBase64 - The AES decryption key in Base64 format.
# + return - A dataset with the specified fields decrypted.
public function decryptData(record {}[] dataset, string[] fieldNames, string keyBase64) returns record {}[]|error {
    do {
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
    } on fail error e {
        return e;
    }
}

# Masks specific fields of a dataset by replacing each character with a specified masking character.
#
# This function iterates through the dataset and replaces all characters (including spaces) in the specified fields
# with the given masking character.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "John Doe", "email": "john@example.com" },
#     { "id": 2, "name": "Jane Smith", "email": "jane@example.com" }
# ];
# string[] fieldNames = ["name", "email"];
# string:Char maskingCharacter = "X";
# record {}[] maskedData = check maskSensitiveData(dataset, fieldNames, maskingCharacter);
# ```
#
# + dataset - The dataset containing records where sensitive fields should be masked.
# + fieldNames - An array of field names that should be masked.
# + maskingCharacter - The character used to replace each character in the sensitive fields.
# + return - A dataset where the specified fields are masked.
public function maskSensitiveData(record {}[] dataset, string[] fieldNames, string:Char maskingCharacter) returns record {}[]|error {
    do {
        record {}[] maskedDataset = [];
        foreach record {} data in dataset {
            record {} maskedData = {};
            foreach string key in data.keys() {
                if fieldNames.some(element => element == key) {
                    maskedData[key] = re `\S|\s`.replaceAll(data[key].toString(), maskingCharacter);
                } else {
                    maskedData[key] = data[key];
                }
            }
            maskedDataset.push(maskedData);
        }
        return maskedDataset;
    } on fail error e {
        return e;
    }
}