import ballerina/lang.regexp;
import ballerina/test;

@test:Config {}
function testStandardizeData() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "John", "city": "new york"},
        {"name": "Charlie", "city": "Los Angeles"}
    ];
    string fieldName = "city";
    string searchValue = "New York";
    record {}[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "John", "city": "New York"},
        {"name": "Charlie", "city": "Los Angeles"}
    ];

    record {}[] result = check standardizeData(dataset, fieldName, searchValue);
    test:assertEquals(result, expected);
}

@test:Config {}
function testGroupApproximateDuplicatess() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Boston"},
        {"name": "John", "city": "Chicago"},
        {"name": "Alice", "city": "new york"},
        {"name": "Charlie", "city": "Los Angeles"},
        {"name": "charlie", "city": "los angeles - usa"}
    ];

    DuplicateGroupingResult expected = {
        uniqueRecords: [
            {"name": "Bob", "city": "Boston"},
            {"name": "John", "city": "Chicago"}
        ],
        duplicateGroups: [
            [{"name": "Alice", "city": "New York"}, {"name": "Alice", "city": "new york"}],
            [{"name": "Charlie", "city": "Los Angeles"}, {"name": "charlie", "city": "los angeles - usa"}]
        ]
    };

    DuplicateGroupingResult result = check groupApproximateDuplicates(dataset);
    test:assertEquals(result.uniqueRecords, expected.uniqueRecords);
    test:assertEquals(result.duplicateGroups, expected.duplicateGroups);
}

@test:Config {}
function testRemoveNull() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": null},
        {"name": "Charlie", "city": ""}
    ];
    record {}[] expected = [
        {"name": "Alice", "city": "New York"}
    ];

    record {}[] result = check removeNull(dataset);
    test:assertEquals(result, expected);
}

@test:Config {}
function testRemoveDuplicates() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Alice", "city": "New York"}
    ];
    record {}[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"}
    ];

    record {}[] result = check removeDuplicates(dataset);
    test:assertEquals(result, expected);
}

@test:Config {}
function testRemoveField() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York", "age": 30},
        {"name": "Bob", "city": "Los Angeles", "age": 25},
        {"name": "Charlie", "city": "Chicago", "age": 35}
    ];
    string fieldName = "age";
    record {}[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Charlie", "city": "Chicago"}
    ];

    record {}[] result = check removeField(dataset, fieldName);
    test:assertEquals(result, expected);
}

@test:Config {}
function testReplaceText() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Charlie", "city": "Chicago"}
    ];
    string fieldName = "city";
    regexp:RegExp searchValue = re `New York`;
    string replaceValue = "San Francisco";
    record {}[] expected = [
        {"name": "Alice", "city": "San Francisco"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Charlie", "city": "Chicago"}
    ];

    record {}[] result = check replaceText(dataset, fieldName, searchValue, replaceValue);
    test:assertEquals(result, expected);
}

@test:Config {}
function testSort() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30},
        {"name": "Charlie", "age": 22}
    ];
    string fieldName = "age";
    boolean isAscending = true;
    record {}[] expected = [
        {"name": "Charlie", "age": 22},
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30}
    ];

    record {}[] result = check sort(dataset, fieldName, isAscending);
    test:assertEquals(result, expected);
}

@test:Config {}
function testHandleWhiteSpaces() returns error? {
    record {}[] dataset = [
        {"name": "  Alice   ", "city": "New   York  "},
        {"name": "   Bob", "city": "Los  Angeles  "}
    ];
    record {}[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"}
    ];

    record {}[] result = check handleWhiteSpaces(dataset);
    test:assertEquals(result, expected);
}
