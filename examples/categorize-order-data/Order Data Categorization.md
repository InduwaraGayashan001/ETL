## Order Data Categorization

## Overview

This example demonstrates the usage of the `etl.categorization` Ballerina module to categorize order data based on the total amount into predefined range categories.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing a CSV file named `order_data.csv` inside the `resources` directory. The file should contain fields `orderId`, `customerName`, and `totalAmount`.

The script performs the following data categorization operations:

1. **Read Order Data**: Loads raw order data from `order_data.csv`.
2. **Categorize Orders**: Groups orders based on the `totalAmount` field into the following ranges:
   - Category 1: 0 - 100
   - Category 2: 100 - 500
   - Category 3: 500 - 1000
   - Category 4: 1000 - 5000
   - Category 5: 5000 - 10000
   - Category 6: Other (amounts outside the defined ranges)
3. **Write Categorized Data**: Saves the categorized data into separate CSV files.

## Run the Example

First, clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The categorized order data is stored in the `resources` directory with the following files:
- `order_data1.csv`: Contains orders in the range 0 - 100.
- `order_data2.csv`: Contains orders in the range 100 - 500.
- `order_data3.csv`: Contains orders in the range 500 - 1000.
- `order_data4.csv`: Contains orders in the range 1000 - 5000.
- `order_data5.csv`: Contains orders in the range 5000 - 10000.
- `order_data6.csv`: Contains orders outside the defined ranges.

