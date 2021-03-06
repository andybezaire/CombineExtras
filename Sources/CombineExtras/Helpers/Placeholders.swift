//
//  Placeholders.swift
//
//
//  Created by Andy Bezaire on 6.3.2021.
//

import Foundation

internal func abstractMethod(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Abstract method call", file: file, line: line)
}
