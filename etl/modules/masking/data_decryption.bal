import ballerina/crypto;
import ballerina/lang.array;

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
