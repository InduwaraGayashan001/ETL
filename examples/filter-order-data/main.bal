import ballerina/io;

import induwaragm/etl.filtering;

type Order record {
    int id;
    string customer;
    float price;
};

public function main() returns error? {
    // Read order data from the CSV file
    Order[] rawOrderData = check io:fileReadCsv("./resources/order_data.csv");

    // Define the field name and the operation to filter orders with price greater than 100
    string fieldName = "price";
    float value = 100.0;

    // Filter orders based on the price being greater than 100
    [record {}[], record {}[]] [expensiveOrders, cheapOrders] = check filtering:filterDataByRelativeExp(rawOrderData, fieldName, filtering:GREATER_THAN, value);

    // Write the filtered data (expensive orders) to a new CSV file
    check io:fileWriteCsv("./resources/expensive_orders.csv", expensiveOrders);

    // Write the filtered data (cheap orders) to another CSV file
    check io:fileWriteCsv("./resources/cheap_orders.csv", cheapOrders);
}

