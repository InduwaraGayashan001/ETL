## Review Data Extraction

## Overview

This example demonstrates the usage of the `etl.extraction` Ballerina module to extract structured insights from unstructured review data.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing a text file named `Input.txt` inside the `resources` directory. The file should contain unstructured review data.

The script performs the following data extraction operations:

1. **Read Review Data**: Loads unstructured review data from `Input.txt`.
2. **Extract Key Insights**: Identifies and categorizes review details into three fields:
   - `goodPoints`: Positive aspects of the reviews.
   - `badPoints`: Negative aspects of the reviews.
   - `improvements`: Suggested improvements.
3. **Write Extracted Data**: Saves the structured review details to `output.json`.

## Configurations

Before running the example, ensure that your `Config.toml` file is set up in the root directory as follows:

```toml
[induwaragm.etl.extraction]
openAIKey = "<OPEN_AI_KEY>"
```

This key is required for processing the data.

## Run the Example

1. Create an [OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys). Replace `<OPEN_AI_KEY>` with the key you obtained.

2. Clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The extracted review data is stored in the `resources` directory in the following file:
- `output.json`: Contains structured insights categorized into `goodPoints`, `badPoints`, and `improvements`.