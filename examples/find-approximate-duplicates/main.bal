import ballerina/io;
import induwaragm/etl.cleaning;

type Customer record {
    string customerId;
    string customerName;
    string email;
    string phone;
    string address;
};

public function main() returns error? {
    Customer[] customers = check io:fileReadCsv("./resources/customers.csv");
    cleaning:DuplicateGroupingResult groupingResult = check cleaning:groupApproximateDuplicates(customers);
    io:println(`Result: ${groupingResult}${"\n"}`);
    check io:fileWriteCsv("./resources/unique_customers.csv", groupingResult.uniqueRecords);
    foreach int i in 0...groupingResult.duplicateGroups.length()-1{
        check io:fileWriteCsv(string `./resources/similar_customers_${i}.csv`, groupingResult.duplicateGroups[i]);
    }  
}
