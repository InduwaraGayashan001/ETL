## Overview

This repository contains the `etl` package, which includes several modules for data processing and manipulation. These modules provide essential functionalities for transforming, cleaning, categorizing, encrypting, and enriching datasets. The package also includes various examples to demonstrate the usage of each module.

## Contents

- **etl.categorization**: Functions for categorizing datasets based on numeric ranges, regular expressions, and semantic classification.
- **etl.cleaning**: Functions for cleaning and standardizing datasets, including removing duplicates and handling null values.
- **etl.enrichment**: Functions for enriching datasets by merging and combining them with additional information.
- **etl.masking**: Functions for securely encrypting and decrypting datasets using AES-ECB encryption.
- **etl.extraction**: Functions for extracting unstructured data and mapping it to structured fields.
- **etl.filtering**: Functions for filtering datasets based on different conditions such as ratios or regex patterns.

## Examples

This repository contains the following examples:

1. **[Extract Unstructured Data](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/extract-unstructured-data)** – Demonstrates how to extract and structure unstructured data into defined fields.  
2. **[Preprocess Customer Data](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/preprocess-customer-data)** – Shows how to preprocess and clean customer data by handling null values, removing duplicates, and standardizing fields.  
3. **[Standardize Customer Data](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/standardize-customer-data)** – Explains how to standardize data in specific fields.  
4. **[Find Approximate Duplicates](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/find-approximate-duplicates)** – Demonstrates how to identify approximate duplicates in customer data.  
5. **[Enrich Customer Data](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/enrich-customer-data)** – Shows how to enrich customer data by merging customer details from multiple CSV files and joining them with contact details.  
6. **[Filter Order Data](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/filter-order-data)** – Explains how to filter order data based on price thresholds.  
7. **[Categorize Order Data](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/categorize-order-data)** – Demonstrates how to categorize order data based on price ranges.  
8. **[Protect Sensitive Data](https://github.com/InduwaraGayashan001/ETL/tree/main/examples/protect-sensitive-data)** – Shows how to protect sensitive data using encryption and masking.
