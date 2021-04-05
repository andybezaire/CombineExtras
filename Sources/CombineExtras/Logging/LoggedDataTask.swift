//
//  File.swift
//  
//
//  Created by Andy on 5.4.2021.
//

import Combine
import Foundation
import os.log

public extension URLSession {
    typealias URLResult = (data: Data, response: URLResponse)
    
    func loggedDataTask(for request: URLRequest, using logger: Logger?, level: OSLogType = .debug, prefix: String = "URL") -> AnyPublisher<URLResult, URLError> {
        logger?.log(level: level, "\(prefix, privacy: .public) request: \(request.oneLiner)")

        return self.dataTaskPublisher(for: request)
            .logOutput(to: logger) { (logger, result) in
                logger.log(level: level, "\(prefix, privacy: .public) response: \(result.response.oneLiner) \(result.data.count) byte(s)")
            }
            .eraseToAnyPublisher()
    }
}
