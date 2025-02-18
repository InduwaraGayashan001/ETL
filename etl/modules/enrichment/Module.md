# `etl.enrichment` Module

## Module Overview

The `etl.enrichment` module provides functions for merging datasets by matching records based on a primary key or combining multiple datasets into one. These operations are essential for enriching datasets by combining additional information from other sources.

## Key Functions

1. **joinData**  
   Merges two datasets based on a common primary key, updating records from the first dataset with matching records from the second.

2. **mergeData**  
   Merges multiple datasets into a single dataset by flattening a nested array of records.
