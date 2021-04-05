//
//  URLRequestOneLinerLogger.swift
//  
//
//  Created by Andy on 5.4.2021.
//

import Foundation

extension URLRequest {
    struct RequestOneLinerLogger {
        let request: URLRequest
    }

    var oneLiner: RequestOneLinerLogger { RequestOneLinerLogger(request: self) }
}

extension URLRequest.RequestOneLinerLogger: CustomStringConvertible {
    var description: String {
        let method = request.httpMethod.map { "\($0) " } ?? ""
        let url = (request.url?.absoluteString).map { "\($0) " } ?? ""
        let headers = request.allHTTPHeaderFields.map { "\($0) " } ?? ""
        let body = request.httpBody.map { "\(String(data: $0, encoding: .utf8) ?? "") " } ?? ""

        return "\(method)\(url)\(headers)\(body)"
    }
}
