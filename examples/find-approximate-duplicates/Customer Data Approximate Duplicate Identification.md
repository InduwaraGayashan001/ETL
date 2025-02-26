## Customer Data Approximate Duplicate Identification

## Overview

This example demonstrates the usage of the `etl.cleaning` Ballerina module to clean customer data by identifying and grouping approximate duplicate records, then saving the results.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing a CSV file named `customers.csv` inside the `resources` directory. The file should contain fields `customerId`, `customerName`, `email`, `phone`, and `address`.

The script performs the following data cleaning operations:

1. **Read Customer Data**: Loads raw customer data from `customers.csv`.
2. **Identify Duplicate Records**: Identifies approximate duplicates in the customer data.
3. **Save Unique Records**: Saves the cleaned data with unique customer records to `unique_customers.csv`.
4. **Save Duplicate Groups**: Saves each group of similar/duplicate customer records to separate CSV files (`similar_customers_0.csv`, `similar_customers_1.csv`, etc.).

## Configurations

Before running the example, ensure that your `Config.toml` file is set up in the root directory as follows:

```toml
[induwaragm.etl.cleaning]
openAIKey = "<OPEN_AI_KEY>"
```

This secret key is used for processing the data and checking for duplicates.

## Run the Example

1. Create an [OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys). Replace `<OPEN_AI_KEY>` with the key you obtained.

2. Clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The processed customer data is stored in the `resources` directory with the following files:
- `unique_customers.csv`: Contains the cleaned customer data with unique records.
- `similar_customers_0.csv`, `similar_customers_1.csv`, etc.: Contain the groups of similar/duplicate customer records.
