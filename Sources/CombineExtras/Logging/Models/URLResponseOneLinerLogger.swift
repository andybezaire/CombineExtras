//
//  URLResponseOneLinerLogger.swift
//
//
//  Created by Andy on 5.4.2021.
//

import Foundation

extension URLResponse {
    struct ResponseOneLinerLogger {
        let response: URLResponse
    }

    var oneLiner: ResponseOneLinerLogger { ResponseOneLinerLogger(response: self) }
}

extension URLResponse.ResponseOneLinerLogger: CustomStringConvertible {
    var description: String {
        let statusCode = (response as? HTTPURLResponse).map { "\($0.statusCode) " } ?? ""
        let url = response.url.map { "\($0.absoluteString) " } ?? ""

        return "\(statusCode)\(url)"
    }
}
