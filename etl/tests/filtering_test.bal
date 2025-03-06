import ballerina/lang.regexp;
import ballerina/test;

@test:Config {}
function testFilterDataByRatio() returns error? {
    record {}[] dataset = [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "name": "Charlie"},
        {"id": 4, "name": "David"}
    ];
    float ratio = 0.75;
    [record {}[], record {}[]] [part1, part2] = check filterDataByRatio(dataset, ratio);
    test:assertEquals(part1.length(), check (dataset.length() * ratio).ensureType(int));
    test:assertEquals(part2.length(), check (dataset.length() * (1.0 - ratio)).ensureType(int));
}

@test:Config {}
function testFilterDataByRegex() returns error? {
    record {}[] dataset = [
        {"id": 1, "city": "New York"},
        {"id": 2, "city": "Los Angeles"},
        {"id": 3, "city": "Newark"},
        {"id": 4, "city": "San Francisco"}
    ];
    string fieldName = "city";
    regexp:RegExp regexPattern = re `^New.*$`;
    record {}[] expectedMatched = [
        {"id": 1, "city": "New York"},
        {"id": 3, "city": "Newark"}
    ];
    record {}[] expectedNonMatched = [
        {"id": 2, "city": "Los Angeles"},
        {"id": 4, "city": "San Francisco"}
    ];
    [record {}[], record {}[]] [matched, nonMatched] = check filterDataByRegex(dataset, fieldName, regexPattern);
    test:assertEquals(matched, expectedMatched);
    test:assertEquals(nonMatched, expectedNonMatched);
}

@test:Config {}
function testFilterDataByRelativeExp() returns error? {
    record {}[] dataset = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 2, "name": "Bob", "age": 30},
        {"id": 3, "name": "Charlie", "age": 22},
        {"id": 4, "name": "David", "age": 28}
    ];
    string fieldName = "age";
    float value = 25;
    record {}[] expectedOlderThan25 = [
        {"id": 2, "name": "Bob", "age": 30},
        {"id": 4, "name": "David", "age": 28}
    ];
    record {}[] expectedYoungerOrEqual25 = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 3, "name": "Charlie", "age": 22}
    ];
    [record {}[], record {}[]] [olderThan25, youngerOrEqual25] = check filterDataByRelativeExp(dataset, fieldName, GREATER_THAN, value);
    test:assertEquals(olderThan25, expectedOlderThan25);
    test:assertEquals(youngerOrEqual25, expectedYoungerOrEqual25);
}
