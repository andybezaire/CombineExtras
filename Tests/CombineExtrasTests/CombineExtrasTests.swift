import Combine
@testable import CombineExtras
import XCTest

final class CombineExtrasTests: XCTestCase {
    class TypeWithSubject {
        public let subject: some Subject = PassthroughSubject<Int, Never>()
    }

    class TypeWithErasedSubject {
        public let subject: some Subject = PassthroughSubject<Int, Never>()
            .eraseToAnySubject()
    }

    func testTypeEraseWorks() {
        let nonErased = TypeWithSubject()
        XCTAssertNotNil(nonErased.subject as? PassthroughSubject<Int, Never>, "direct cast should work")

        let erased = TypeWithErasedSubject()
        XCTAssertNil(erased.subject as? PassthroughSubject<Int, Never>, "cast should not work after type erase")
    }

    static var allTests = [
        ("testTypeEraseWorks", testTypeEraseWorks),
    ]
}
