import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CombineExtrasTests.allTests),
        testCase(LoggingDataTaskTests.allTests),
        testCase(LoggingTests.allTests),
    ]
}
#endif
