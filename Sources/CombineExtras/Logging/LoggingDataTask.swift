//
//  LoggingDataTask.swift
//  
//
//  Created by Andy on 5.4.2021.
//

import Combine
import Foundation
import os.log

public extension URLSession {
    typealias URLResult = (data: Data, response: URLResponse)
    
    /// Creates a publisher that wraps a URL session data task for a given URL request,
    /// printing the request and response with one liners to a logger
    ///
    /// - Note: The request is logged upon creation of the publisher, NOT subscription start.
    /// - Parameters:
    ///   - request: The `URLRequest` for which to create a data task.
    ///   - logger: The optional `Logger` to log to
    ///   - level: The level to log to. Defaults to `.debug`
    ///   - prefix: The `String` to print at the beginning of a log output line. Defaults to `"URL"`
    /// - Returns: A URL session data task publisher for the given URL request
    func loggingDataTask(
        for request: URLRequest,
        using logger: Logger?,
        level: OSLogType = .debug,
        prefix: String = "URL"
    ) -> AnyPublisher<URLResult, URLError> {
        logger?.log(level: level, "\(prefix, privacy: .public) request: \(request.oneLiner)")

        return self.dataTaskPublisher(for: request)
            .logOutput(to: logger) { (logger, result) in
                logger.log(level: level, "\(prefix, privacy: .public) response: \(result.response.oneLiner) \(result.data.count) byte(s)")
            }
            .eraseToAnyPublisher()
    }
}
