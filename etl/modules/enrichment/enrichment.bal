# Merges two datasets based on a common primary key, updating records from the first dataset with matching records from the second.
# ```ballerina
# record {}[] dataset1 = [{id: 1, name: "Alice"}, {id: 2, name: "Bob"}];
# record {}[] dataset2 = [{id: 1, age: 25}, {id: 2, age: 30}];
# string primaryKey = "id";
# record {}[] mergedData = check enrichment:joinData(dataset1, dataset2, primaryKey);
# ```
#
# + dataset1 - First dataset containing base records.
# + dataset2 - Second dataset with additional data to be merged.
# + primaryKey - The field used to match records between the datasets.
# + return - A merged dataset with updated records or an error if merging fails.
public function joinData(record {}[] dataset1, record {}[] dataset2, string primaryKey) returns record {}[]|error {
    do {
        record {}[] updatedCustomers = [];
        record {}[][] similarCustomers = from record {} data1 in dataset1
            join record {} data2 in dataset2 on data1[primaryKey] equals data2[primaryKey]
            select [data1, data2];
        foreach record {}[] similarCustomer in similarCustomers {
            foreach string key in similarCustomer[1].keys() {
                similarCustomer[0][key] = similarCustomer[1][key];
            }
            updatedCustomers.push(similarCustomer[0]);
        }
        return updatedCustomers;
    } on fail error e {
        return e;
    }
}

# Merges multiple datasets into a single dataset by flattening a nested array of records.
# ```ballerina
# record {}[][] dataSets = [
#     [{id: 1, name: "Alice"}, {id: 2, name: "Bob"}],
#     [{id: 3, name: "Charlie"}, {id: 4, name: "David"}]
# ];
# record {}[] mergedData = check enrichment:mergeData(dataSets);
# ```
#
# + datasets - An array of datasets, where each dataset is an array of records.
# + return - A single merged dataset containing all records or an error if merging fails.
public function mergeData(record {}[][] datasets) returns record {}[]|error {
    do {
        return from record {}[] dataSet in datasets
            from record {} data in dataSet
            select data;
    } on fail error e {
        return e;
    }
}
