import ballerina/test;

@test:Config {}
function testExtractUnstructuredData() returns error? {
    string[] reviews = [
        "The product is excellent, but it needs better battery life.",
        "Great performance, but the UI is a bit outdated.",
        "Amazing build quality, but it's quite expensive."
    ];

    string[] fields = ["goodPoints", "badPoints", "improvements"];
    record {} extractedDetails = check extractUnstructuredData(reviews, fields);

    test:assertNotEquals(extractedDetails["goodPoints"], null);
    test:assertNotEquals(extractedDetails["badPoints"], null);
    test:assertNotEquals(extractedDetails["improvements"], null);
}
