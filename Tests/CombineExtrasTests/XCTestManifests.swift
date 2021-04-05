import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CombineExtrasTests.allTests),
        testCase(LoggedDataTaskTests.allTests),
        testCase(LoggingTests.allTests),
    ]
}
#endif
