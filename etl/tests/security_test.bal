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

    record {}[] encryptedData = check encryptData(dataset, ["name", "age"], keyBase64);
    test:assertEquals(encryptedData.length(), dataset.length());
}

@test:Config {}
function testDecryptData() returns error? {
    record {}[] encryptedData = [
        {"id": 1, "name": "kHKa63v98rbDm+FB2DJ3ig==", "age": "DwknVxmigukb2VBkDj2rHg=="},
        {"id": 2, "name": "S0x+hpmvSOIT7UE8hOGZkA==", "age": "goBjsnnKAMRoEfkZsbRYwg=="}
    ];
    string keyBase64 = "TgMtILI4IttHFilanAdZbw==";

    record {}[] expectedDecryptedData = [
        {"id": 1, "name": "Alice", "age": "25"},
        {"id": 2, "name": "Bob", "age": "30"}
    ];

    record {}[] decryptedData = check decryptData(encryptedData, ["name", "age"], keyBase64);
    test:assertEquals(decryptedData, expectedDecryptedData);
}

@test:Config {}
function testMaskSensitiveData() returns error? {
    record {}[] dataset = [
        {"id": 1, "name": "John Doe", "email": "john@example.com"},
        {"id": 2, "name": "Jane Smith", "email": "jane@example.com"},
        {"id": 3, "name": "Alice", "email": "alice@example.com"}
    ];

    record {}[] expectedOutput = [
        {"id": 1, "name": "XXXX XXX", "email": "XXXXXXXXXXXXXXXX"},
        {"id": 2, "name": "XXXX XXXXX", "email": "XXXXXXXXXXXXXXXX"},
        {"id": 3, "name": "XXXXX", "email": "XXXXXXXXXXXXXXXXX"}
    ];

    record {}[] maskedData = check maskSensitiveData(dataset);
    test:assertEquals(maskedData, expectedOutput);
}
