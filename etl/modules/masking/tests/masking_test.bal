import ballerina/test;

type Person record {
    string name;
    int age;
};

@test:Config {}
function testEncryptData() returns error? {
    record {}[] dataset = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 2, "name": "Bob", "age": 30}
    ];
    string keyBase64 = "TgMtILI4IttHFilanAdZbw==";

    string[] encryptedData = check encryptData(dataset, keyBase64);
    test:assertEquals(encryptedData.length(), dataset.length());
}

@test:Config {}
function testDecryptData() returns error? {
    string[] encryptedData = ["s8VbGE1kQdXTwp1tHECCBwKSDybVK86XAUqHjsNKiR8=", "030h3xL9he3/xeVIecdCZX7xxvBZHpgqcGYR6y4dIYY="];
    string keyBase64 = "TgMtILI4IttHFilanAdZbw==";

    record {}[] expectedDecryptedData = [
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30}
    ];

    record {}[] decryptedData = check decryptData(encryptedData, keyBase64, Person);
    test:assertEquals(decryptedData, expectedDecryptedData);
}
