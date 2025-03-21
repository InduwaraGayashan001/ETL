# Represents the available comparison operations.
#
# + GREATER_THAN - Checks if the left operand is greater than the right operand.
# + LESS_THAN - Checks if the left operand is less than the right operand.
# + EQUAL - Checks if the left and right operands are equal.
# + NOT_EQUAL - Checks if the left and right operands are not equal.
# + GREATER_THAN_OR_EQUAL - Checks if the left operand is greater than or equal to the right operand.
# + LESS_THAN_OR_EQUAL - Checks if the left operand is less than or equal to the right operand.
public enum Operation {
    GREATER_THAN = ">",
    LESS_THAN = "<",
    EQUAL = "==",
    NOT_EQUAL = "!=",
    GREATER_THAN_OR_EQUAL = ">=",
    LESS_THAN_OR_EQUAL = "<="
}

# Represents the result of duplicate grouping in a dataset.
#
# + uniqueRecords - An array of records that are identified as unique (non-duplicate).
# + duplicateGroups - An array of arrays, where each inner array contains records that are identified as duplicates of each other.
public type DuplicateGroupingResult record {
    record {}[] uniqueRecords;
    record {}[][] duplicateGroups;
};

