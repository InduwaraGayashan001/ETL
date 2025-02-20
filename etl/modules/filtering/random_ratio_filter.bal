import ballerina/random;

# Splits a dataset into two parts based on a given ratio.
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice" },
#     { "id": 2, "name": "Bob" },
#     { "id": 3, "name": "Charlie" },
#     { "id": 4, "name": "David" }
# ];
# float ratio = 0.75;
# [record {}[], record {}[]] [part1, part2] = check filterDataByRatio(dataset, ratio);
# ```
#
# + dataset - Array of records to be split.
# + ratio - The ratio for splitting the dataset (e.g., `0.75` means 75% in the first set).
# + return - A tuple containing two subsets of the dataset.
public function filterDataByRatio(record {}[] dataset, float ratio) returns [record {}[], record {}[]]|error {
    do {
        function (record {}[] data) returns record {}[]|error shuffle = function(record {}[] data) returns record {}[]|error {
            int dataLength = data.length();
            foreach int i in 0 ... dataLength - 1 {
                int randomIndex = check random:createIntInRange(i, dataLength);
                record {} temp = data[i];
                data[i] = data[randomIndex];
                data[randomIndex] = temp;
            }
            return data;
        };
        int dataLength = dataset.length();
        int splittingPoint = <int>(dataLength * ratio);
        record {}[] shuffledData = check shuffle(dataset);
        return [shuffledData.slice(0, splittingPoint), shuffledData.slice(splittingPoint)];
    } on fail error e {
        return e;
    }

}
