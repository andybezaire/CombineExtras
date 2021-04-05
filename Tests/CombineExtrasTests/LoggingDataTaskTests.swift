//
//  LoggingDataTaskTests.swift
//  
//
//  Created by Andy on 5.4.2021.
//

import Combine
@testable import CombineExtras
import Mocker
import os.log
import XCTest

final class LoggingDataTaskTests: XCTestCase {
    var cancellable: AnyCancellable?
    
    struct Sample: Codable {
        let name: String
        let age: Int
    }
    
    let sample1 = Sample(name: "Sample1", age: 22)

    /// testIsLogged
    ///
    /// this output needs to be visually inspected to match:
    ///
    ///      // sample output:
    ///      // 2021-04-05 10:16:25.967813+0300 subsystem[20595:1215710] [main] Test request: GET http://example.com
    ///      // 2021-04-05 10:16:25.973424+0300 subsystem[20595:1216143] [main] Test response: 200 http://example.com  0 byte(s)
    func testIsLogged() {
        let logger = Logger(subsystem: "com.example.subsystem", category: "main")

        let publisherCompleted = XCTestExpectation(description: "The publisher has completed")

        let url = URL(string: "http://example.com")!
        var request: URLRequest { URLRequest(url: url) }

        Mock(url: url, dataType: .json, statusCode: 200, data: [.get: Data()])
            .register()

        cancellable = URLSession.shared.loggingDataTask(for: request, using: logger, level: .info, prefix: "Test")
            .sink { _ in publisherCompleted.fulfill() } receiveValue: { _ in }

        wait(for: [publisherCompleted], timeout: 1)
    }
    
    /// testIsLoggedWithBodys
    ///
    /// this output needs to be visually inspected to match:
    ///
    ///      // sample output:
    ///      // 2021-04-05 10:31:11.056163+0300 subsystem[20738:1225036] [main] Test request: POST http://example.com ["Accept": "application/json"] {"name":"Sample1","age":22}
    ///      // 2021-04-05 10:31:11.061316+0300 subsystem[20738:1225067] [main] Test response: 200 http://example.com  27 byte(s)

    func testIsLoggedWithBodys() {
        let logger = Logger(subsystem: "com.example.subsystem", category: "main")

        let publisherCompleted = XCTestExpectation(description: "The publisher has completed")

        let url = URL(string: "http://example.com")!
        var request: URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONEncoder().encode(sample1)
            return request
        }

        Mock(url: url, dataType: .json, statusCode: 200, data: [.post: try! JSONEncoder().encode(sample1)])
            .register()

        cancellable = URLSession.shared.loggingDataTask(for: request, using: logger, level: .info, prefix: "Test")
            .sink { _ in publisherCompleted.fulfill() } receiveValue: { _ in }

        wait(for: [publisherCompleted], timeout: 1)
    }

    /// testIsLoggedWithBodysUsingDefaults
    ///
    /// this output needs to be visually inspected to match:
    ///
    ///      // sample output:
    ///      // 2021-04-05 10:35:56.029459+0300 subsystem[20804:1228035] [main] URL request: POST http://example.com ["Accept": "application/json"] {"name":"Sample1","age":22}
    ///      // 2021-04-05 10:35:56.034937+0300 subsystem[20804:1228476] [main] URL response: 200 http://example.com  27 byte(s)

    func testIsLoggedWithBodysUsingDefaults() {
        let logger = Logger(subsystem: "com.example.subsystem", category: "main")

        let publisherCompleted = XCTestExpectation(description: "The publisher has completed")

        let url = URL(string: "http://example.com")!
        var request: URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONEncoder().encode(sample1)
            return request
        }

        Mock(url: url, dataType: .json, statusCode: 200, data: [.post: try! JSONEncoder().encode(sample1)])
            .register()

        cancellable = URLSession.shared.loggingDataTask(for: request, using: logger)
            .sink { _ in publisherCompleted.fulfill() } receiveValue: { _ in }

        wait(for: [publisherCompleted], timeout: 1)
    }

    static var allTests = [
        ("testURLIsLogged", testIsLogged),
        ("testIsLoggedWithBodys", testIsLoggedWithBodys),
        ("testIsLoggedWithBodysUsingDefaults", testIsLoggedWithBodysUsingDefaults),
    ]
}
