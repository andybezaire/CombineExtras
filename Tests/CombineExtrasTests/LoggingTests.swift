//
//  LoggingTests.swift
//
//
//  Created by Andy Bezaire on 16.3.2021.
//

import Combine
@testable import CombineExtras
import os.log
import XCTest

final class LoggingTests: XCTestCase {
    var cancellable: AnyCancellable?

    /// testExampleIsLogged
    ///
    /// this output needs to be visually inspected to match:
    ///
    ///      // sample output:
    ///      // 2021-03-16 20:41:10.980102+0200 subsystem[47288:1810254] [main] Counter started
    ///      // 2021-03-16 20:41:10.980252+0200 subsystem[47288:1810254] [main] Counter got 1 new coin(s)
    ///      // 2021-03-16 20:41:10.980361+0200 subsystem[47288:1810254] [main] Counter got 2 new coin(s)
    ///      // 2021-03-16 20:41:10.980451+0200 subsystem[47288:1810254] [main] Counter got 3 new coin(s)
    ///      // 2021-03-16 20:41:10.980578+0200 subsystem[47288:1810254] [main] Counter finished
    func testExampleIsLogged() {
        let logger = Logger(subsystem: "com.example.subsystem", category: "main")

        let publisherCompleted = XCTestExpectation(description: "The publisher has completed")

        cancellable = [1, 2, 3].publisher
            .log(to: logger, prefix: "Counter") { logger, output in
                logger.log("Counter got \(output, privacy: .private) new coin(s)")
            }
            .sink { _ in publisherCompleted.fulfill() } receiveValue: { _ in }

        wait(for: [publisherCompleted], timeout: 1)
    }

    /// testExampleOutputIsLogged
    ///
    /// this output needs to be visually inspected to match:
    ///
    ///      // sample output:
    ///      // 2021-03-16 20:41:10.980252+0200 subsystem[47288:1810254] [main] Counter got 1 new coin(s)
    ///      // 2021-03-16 20:41:10.980361+0200 subsystem[47288:1810254] [main] Counter got 2 new coin(s)
    ///      // 2021-03-16 20:41:10.980451+0200 subsystem[47288:1810254] [main] Counter got 3 new coin(s)
    func testExampleOutputIsLogged() {
        let logger = Logger(subsystem: "com.example.subsystem", category: "main")

        let publisherCompleted = XCTestExpectation(description: "The publisher has completed")

        cancellable = [1, 2, 3].publisher
            .logOutput(to: logger) { logger, output in
                logger.log("Counter got \(output, privacy: .private) new coin(s)")
            }
            .sink { _ in publisherCompleted.fulfill() } receiveValue: { _ in }

        wait(for: [publisherCompleted], timeout: 1)
    }

    static var allTests = [
        ("testExampleIsLogged", testExampleIsLogged),
        ("testExampleOutputIsLogged", testExampleOutputIsLogged),
    ]
}
