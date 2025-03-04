import ballerina/io;

import induwaragm/etl.cleaning;

type Customer record {|
    string name;
    string city;
    string phone;
    int age;
|};

public function main() returns error? {

    Customer[] customers = check io:fileReadCsv("./resources/customers.csv");
    io:println(customers);
    record {}[] updatedCustomers = check cleaning:standardizeData(customers, "city", "New York", "gpt-4o-mini");

    io:println(`Updated Customers: ${updatedCustomers}${"\n"}`);
    check io:fileWriteCsv("./resources/updated_customers.csv", updatedCustomers);
}
