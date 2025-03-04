import ballerina/io;

import induwaragm/etl.cleaning;

type Customer record {
    string? name;
    int? age?;
    string? phone;
    string? email;
};

public function main() returns error? {
    // Read customer data from the CSV file
    Customer[] rawCustomerData = check io:fileReadCsv("./resources/customer_data.csv");

    // Remove age field from the customer data
    record {}[] cleanedCustomers = check cleaning:removeField(rawCustomerData, "age");

    // Trim white spaces in all fields
    record {}[] trimmedCustomerData = check cleaning:handleWhiteSpaces(cleanedCustomers);

    // Remove records with null values
    record {}[] nonNullCustomerData = check cleaning:removeNull(trimmedCustomerData);

    // Remove duplicate records
    record {}[] uniqueCustomerData = check cleaning:removeDuplicates(nonNullCustomerData);

    // Sort customer records by name
    record {}[] sortedCustomerData = check cleaning:sort(uniqueCustomerData, "name");

    // Format phone numbers by replacing leading zeros with the country code "+94"
    record {}[] formattedCustomerData = check cleaning:replaceText(sortedCustomerData, "phone", re `^0+`, "+94");

    // Write the cleaned and formatted data back to a new CSV file
    check io:fileWriteCsv("./resources/preprocessed_customer_data.csv", formattedCustomerData);
}
