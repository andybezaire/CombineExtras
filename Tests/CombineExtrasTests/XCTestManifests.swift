import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CombineExtrasTests.allTests),
        testCase(LoggingTests.allTests),
    ]
}
#endif
