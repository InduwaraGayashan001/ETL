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
function encryptData(record {}[] dataset, string[] fieldNames, string keyBase64) returns record {}[]|error {
    do {
        byte[] encryptkey = check array:fromBase64(keyBase64);
        record {}[] encryptedDataSet = [];
        foreach record {} data in dataset {
            record {} newData = {};
            foreach string key in data.keys() {
                if fieldNames.some(element => element == key) {
                    byte[] dataByte = data[key].toString().toBytes();
                    byte[] cipherText = check crypto:encryptAesEcb(dataByte, encryptkey);
                    newData[key] = cipherText.toBase64();
                } else {
                    newData[key] = data[key];
                }
            }
            encryptedDataSet.push(newData);
        }
        return encryptedDataSet;
    } on fail error e {
        return e;
    }
}

//new function to find sensitive data and replace
