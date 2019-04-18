//
//  Range+Helpers.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension Range where Bound == String.Index {
    
    func makeNSRange(_ string: String) -> NSRange {
        let location: Int = string.distance(from: string.startIndex, to: self.lowerBound)
        let length: Int = string.distance(from: self.lowerBound, to: self.upperBound)
        return NSRange(location: location, length: length)
    }
    
}

extension NSRange {
    
    func makeStringRange(_ string: String) -> StringRange {
        let stringLowerBound: String.Index = string.index(string.startIndex, offsetBy: self.lowerBound)
        let stringUpperBound: String.Index = string.index(string.startIndex, offsetBy: self.upperBound)
        return stringLowerBound..<stringUpperBound
    }
    
}
