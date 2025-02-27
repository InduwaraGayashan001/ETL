import ballerina/io;
import induwaragm/etl.security;

configurable string key =?;

type Customer record {
    string customerId;
    string name;
    string city;
    string phone;
    int age;
    string ssn;
    string email;
};

type EncryptedCustomer record {
    string customerId;
    string name;
    string city;
    string phone;
    string age;
    string ssn;
    string email;
};

public function main() returns error? {
    // Encrypt the data
    Customer[] customers = check io:fileReadCsv("./resources/customers.csv");
    record{}[] encryptedCustomers = check security:encryptData(customers,["ssn","email"] ,key);
    check io:fileWriteCsv("./resources/encrypted_customers.csv", encryptedCustomers);

    // Decrypt the data
    EncryptedCustomer[] encryptedData = check io:fileReadCsv("./resources/encrypted_customers.csv");
    record {}[] decryptedData = check security:decryptData(encryptedData,["ssn","email"], key);
    check io:fileWriteCsv("./resources/decrypted_customers.csv", decryptedData);

    // Mask sensitive data
    record{}[] maskedCustomers = check security:maskSensitiveData(customers,"x");
    check io:fileWriteCsv("./resources/masked_customers.csv", maskedCustomers);

}
