import ballerina/crypto;
import ballerina/lang.array;

# Decrypts a dataset using AES-ECB decryption with a given Base64-encoded key and returns records of the specified type.
#
# ```ballerina
# string[] encryptedData = [
#     "sdfjsdlfjsdl==", 
#     "j34nkj23n4k3=="
# ];
# string keyBase64 = "aGVsbG9zZWNyZXRrZXkxMjM0NTY=";
# typedesc<record { string name; int age; }> dataType = record { string name; int age; };
# record {}[] decryptedData = check decryptData(encryptedData, keyBase64, dataType);
# ```
#
# + dataSet - The dataset containing the Base64-encoded encrypted strings to be decrypted.
# + keyBase64 - The AES decryption key in Base64 format.
# + dataType - The type descriptor of the record to be returned after decryption.
# + return - An array of decrypted records in the specified `dataType`.
public function decryptData(string[] dataSet, string keyBase64, typedesc<record {}> dataType) returns record {}[]|error {
    do {
        byte[] decryptKey = check array:fromBase64(keyBase64);
        record {}[] decryptededDataSet = [];

        foreach int i in 0 ... dataSet.length() - 1 {
            byte[] dataByte = check array:fromBase64(dataSet[i]);
            byte[] plainText = check crypto:decryptAesEcb(dataByte, decryptKey);
            string plainTextString = check string:fromBytes(plainText);
            decryptededDataSet.push(check (check plainTextString.fromJsonString()).cloneWithType(dataType));
        }
        return decryptededDataSet;
    } on fail error e {
        return e;
    }
}
