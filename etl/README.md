# `etl` Package

## Package Overview

The `etl` (Extract, Transform, Load) package provides a collection of modules designed for data processing and manipulation. These modules focus on data extraction, transformation, filtering, encryption, categorization, enrichment, cleaning, and more. The package enables seamless ETL workflows, supporting a variety of use cases such as text data extraction, data categorization, enrichment, secure data masking, data cleaning, and organization.

## Key Modules

### 1. `etl.extraction` Module
The `etl.extraction` module provides functions for extracting data.
**Key Functions:**
- `extractUnstructuredData`: Extracts relevant details from a string array and maps them to the specified fields using OpenAI's GPT model.

### 2. `etl.filtering` Module
The `etl.filtering` module provides functions to filter datasets based on different conditions.

**Key Functions:**
- `filterDataByRatio`: Splits a dataset into two parts based on a given ratio.
- `filterDataByRegex`: Filters a dataset into two subsets based on a regex pattern match.
- `filterDataByRelativeExp`: Filters a dataset based on a relative numeric comparison expression.

### 3. `etl.masking` Module
The `etl.masking` module provides functions for securely encrypting and decrypting datasets using AES-ECB encryption. 

**Key Functions:**
- `encryptData`: Encrypts a dataset using AES-ECB encryption with a given Base64-encoded key.
- `decryptData`: Decrypts a dataset using AES-ECB decryption with a given Base64-encoded key, returning records of the specified type.

### 4. `etl.categorization` Module
The `etl.categorization` module provides functions for categorizing datasets based on different criteria such as numeric ranges, regular expressions, and semantic classification. 

**Key Functions:**
- `categorizeNumeric`: Categorizes a dataset based on a numeric field and specified ranges.
- `categorizeRegexData`: Categorizes a dataset based on a string field using a set of regular expressions.
- `categorizeSemantic`: Categorizes a dataset based on a string field using semantic classification via OpenAI's GPT model.

### 5. `etl.cleaning` Module
The `etl.cleaning` module provides functions for cleaning and standardizing datasets. 

**Key Functions:**
- `standardizeData`: Standardizes a dataset by replacing approximate matches in a string field with a specified search value.
- `removeApproximateDuplicates`: Removes approximate duplicates from a dataset, keeping only the first occurrence of each duplicate record.
- `removeNull`: Removes records that contain null or empty string values in any field.
- `removeDuplicates`: Removes exact duplicate records from a dataset based on their content.
- `removeField`: Removes a specified field from each record in the dataset.
- `replaceText`: Replaces text in a specific field of a dataset using regular expressions.
- `sort`: Sorts a dataset based on a specific field in ascending or descending order.
- `handleWhiteSpaces`: Cleans up whitespace in all fields of a dataset by replacing multiple spaces with a single space and trimming the values.

### 6. `etl.enrichment` Module
The `etl.enrichment` module provides functions for merging datasets by matching records based on a primary key or combining multiple datasets into one. 
**Key Functions:**
- `joinData`: Merges two datasets based on a common primary key, updating records from the first dataset with matching records from the second.
- `mergeData`: Merges multiple datasets into a single dataset by flattening a nested array of records.


