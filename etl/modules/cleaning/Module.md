# `etl.cleaning` Module

## Module Overview

The `etl.cleaning` module provides functions for cleaning and standardizing datasets. It includes functionality to handle null values, remove duplicates, standardize string fields, and modify text content using regular expressions. These operations are essential for preparing data for further analysis or processing.

## Key Functions

1. **standardizeData**  
   Standardizes a dataset by replacing approximate matches in a string field with a specified search value.

2. **removeApproximateDuplicates**  
   Removes approximate duplicates from a dataset, keeping only the first occurrence of each duplicate record.

3. **removeNull**  
   Removes records that contain null or empty string values in any field.

4. **removeDuplicates**  
   Removes exact duplicate records from a dataset based on their content.

5. **removeField**  
   Removes a specified field from each record in the dataset.

6. **replaceText**  
   Replaces text in a specific field of a dataset using regular expressions.

7. **sort**  
   Sorts a dataset based on a specific field in ascending or descending order.

8. **handleWhiteSpaces**  
   Cleans up whitespace in all fields of a dataset by replacing multiple spaces with a single space and trimming the values.
