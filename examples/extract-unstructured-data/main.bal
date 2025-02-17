import ballerina/io;
import induwaragm/etl.extraction;

type ReviewSummary record {|
    string goodPoints;
    string badPoints;
    string improvements;
|};

public function main(string[] arg) returns error? {

    string[] reviews = check io:fileReadLines("./resources/Input.txt");
    string[] fields = ["goodPoints", "badPoints", "improvements"];
    record {} extractedDetails = check extraction:extractUnstructuredData(reviews, fields);
    io:println(`Extracted Details : ${extractedDetails.cloneWithType(ReviewSummary)}`);
    check io:fileWriteJson("./resources/output.json", extractedDetails.toJson());
}