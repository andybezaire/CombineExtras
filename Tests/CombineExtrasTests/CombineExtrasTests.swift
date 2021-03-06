import XCTest
@testable import CombineExtras

final class CombineExtrasTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CombineExtras().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
