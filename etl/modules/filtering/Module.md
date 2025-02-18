# `etl.filtering` Module

## Module Overview

The `etl.filtering` module provides functions for filtering and splitting datasets based on various conditions. These functions help in processing and organizing data by dividing or extracting subsets according to specific criteria such as ratios, regular expressions, or numeric comparisons.

## Key Functions

1. **filterDataByRatio**  
   Splits a dataset into two parts based on a given ratio, shuffling the data before splitting.

2. **filterDataByRegex**  
   Filters a dataset into two subsets based on a regex pattern match applied to a specified field.

3. **filterDataByRelativeExp**  
   Filters a dataset based on a relative numeric comparison, evaluating fields against a specified condition (e.g., `>`, `<`, `>=`, `<=`, `==`, `!=`).
