import ballerina/io;
import induwaragm/etl.categorization;

type Order record {|
    string orderId;
    string customerName;
    float totalAmount;
|};

public function main() returns error? {

    // Read orders from a CSV file
    Order[] orders = check io:fileReadCsv("./resources/order_data.csv");

    // Define amount range categories
    float[][] rangeArray = [[0, 100], [100, 500], [500, 1000], [1000, 5000], [5000, 10000]];
    
    // Categorize orders based on totalAmount
    record {}[][] categorizedOrders = check categorization:categorizeNumeric(orders, "totalAmount", rangeArray);
    
    io:println(`Category 1 (Amount 0-100): ${categorizedOrders[0]} ${"\n\n"}Category 2 (Amount 100-500): ${categorizedOrders[1]} ${"\n\n"}Category 3 (Amount 500-1000): ${categorizedOrders[2]} ${"\n\n"}Category 4 (Amount 1000-5000): ${categorizedOrders[3]} ${"\n\n"}Category 5 (Amount 5000-10000): ${categorizedOrders[4]} ${"\n\n"}Category 6 (Other): ${categorizedOrders[5]} ${"\n"}`);
    
    // Save categorized orders to separate CSV files
    foreach int i in 0 ... rangeArray.length() {
        check io:fileWriteCsv(string `./resources/order_data${i + 1}.csv`, categorizedOrders[i]);
    }
}

