//
//  AttributedStringBuilder.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

class AttributedstringBuilder {
    
    // MARK: - Properties
    
    private var attributedString: NSMutableAttributedString
    
    var string: String {
        return self.attributedString.string
    }
    
    // MARK: - Init
    
    init(text: String) {
        self.attributedString = NSMutableAttributedString(string: text)
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func setValue(_ value: Any, key: NSAttributedString.Key, in range: StringRange) -> AttributedstringBuilder {
        let result: AttributedstringBuilder = self
        let nsRange: NSRange = range.makeNSRange(self.string)
        result.attributedString.setAttributes([key: value], range: nsRange)
        return result
    }
    
    func ranges(of otherString: String) -> [StringRange] {
        var result: [StringRange] = []
        var searchRange: StringRange = self.string.startIndex..<self.string.endIndex
        var searchCondition: Bool = self.string.distance(from: searchRange.lowerBound, to: searchRange.upperBound) > 0
        while searchCondition {
            guard let range: StringRange = self.string.range(of: otherString, range: searchRange) else {
                searchCondition = false
                continue
            }
            searchRange = range.upperBound..<self.string.endIndex
            result.append(range)
        }
        return result
    }
    
    func build() -> NSAttributedString {
        return NSAttributedString(attributedString: self.attributedString)
    }
    
}
