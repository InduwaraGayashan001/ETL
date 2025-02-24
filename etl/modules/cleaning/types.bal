# Represents the result of duplicate grouping in a dataset.
#
# + uniqueRecords - An array of records that are identified as unique (non-duplicate).
# + duplicateGroups - An array of arrays, where each inner array contains records that are identified as duplicates of each other.
public type DuplicateGroupingResult record {
    record {}[] uniqueRecords;
    record {}[][] duplicateGroups;
};
