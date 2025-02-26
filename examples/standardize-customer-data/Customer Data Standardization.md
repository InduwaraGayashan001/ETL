## Customer Data Cleaning and Standardization

## Overview

This example demonstrates the usage of the `etl.cleaning` Ballerina module to standardize customer data by updating city names to a specified value.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing a CSV file named `customers.csv` inside the `resources` directory. The file should contain fields `name`, `city`, `phone`, and `age`.

The script performs the following data cleaning operations:

1. **Read Customer Data**: Loads raw customer data from `customers.csv`.
2. **Standardize City Names**: Updates the `city` field to `New York` where applicable.
3. **Write Updated Data**: Saves the standardized data to `updated_customers.csv`.

## Configurations

Before running the example, set up the following configurations in a `Config.toml` file in the root directory:

```toml
[induwaragm.etl.cleaning]
openAIKey = "<OPEN_AI_KEY>"
```

## Run the Example

1. Create an [OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys) and replace `<OPEN_AI_KEY>` with the key you obtained.

2. Clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The processed customer data is stored in the `resources` directory in the following file:
- `updated_customers.csv`: Contains the standardized city names for customer records.
