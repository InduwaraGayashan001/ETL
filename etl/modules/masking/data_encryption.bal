import ballerina/crypto;
import ballerina/lang.array;

# Encrypts a dataset using AES-ECB encryption with a given Base64-encoded key.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 }
# ];
# string keyBase64 = "aGVsbG9zZWNyZXRrZXkxMjM0NTY=";
# string[] encryptedData = check encryptData(dataset, keyBase64);
# ```
#
# + dataSet - The dataset containing records to be encrypted.
# + keyBase64 - The AES encryption key in Base64 format.
# + return - An array of Base64-encoded encrypted strings.
public function encryptData(record {}[] dataSet, string keyBase64) returns string[]|error {
    do {
        byte[] encryptkey = check array:fromBase64(keyBase64);
        string[] encryptedDataSet = [];

        foreach int i in 0 ... dataSet.length() - 1 {
            byte[] dataByte = dataSet[i].toString().toBytes();
            byte[] cipherText = check crypto:encryptAesEcb(dataByte, encryptkey);
            encryptedDataSet.push(cipherText.toBase64());
        }
        return encryptedDataSet;
    } on fail error e {
        return e;
    }
}
