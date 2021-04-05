//
//  Truncation.swift
//  
//
//  Created by Andy on 5.4.2021.
//

import Foundation

extension String {
    enum TruncationPosition {
        case head
        case middle
        case tail
    }

    func truncated(limit: Int, position: TruncationPosition = .tail, leader: String = "...") -> String {
        guard self.count > limit else { return self }

        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))

            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            return self.prefix(limit) + leader
        }
    }
}

extension Dictionary where Value == String {
    func truncated(limit: Int, position: String.TruncationPosition = .tail, leader: String = "...") -> Self {
        var dictionary = self
        dictionary.forEach { key, value in
            dictionary[key] = value.truncated(limit: limit, position: position, leader: leader)
        }
        return dictionary
    }
}
