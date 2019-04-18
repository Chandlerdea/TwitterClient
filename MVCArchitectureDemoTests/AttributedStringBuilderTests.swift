//
//  AttributedStringBuilderTests.swift
//  MVCArchitectureDemoTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import MVCArchitectureDemo

class AttributedStringBuilderTests: XCTestCase {

    func testThatValueIsSet() {
        
        let string: String = "A test"
        let blueRange: StringRange = string.index(string.startIndex, offsetBy: 2)..<string.endIndex
        let attrString: NSAttributedString = AttributedstringBuilder(text: string).setValue(UIColor.blue, key: .foregroundColor, in: blueRange).build()
        var effectiveRange: NSRange = NSRange(location: 2, length: string.count)
        let attrs: [NSAttributedString.Key: Any] = attrString.attributes(at: 2, effectiveRange: &effectiveRange)
        
        XCTAssertEqual(attrs[.foregroundColor] as? UIColor, UIColor.blue)
    }
    
    func testThatRangesAreCorrect() {
        
        let string: String = "A test of handles like @chandler and @chandler, and then another one like @carter and @chandler"
        
        let chandlerRanges: [StringRange] = AttributedstringBuilder(text: string).ranges(of: "@chandler")
        let expectedChandlerRanges: [StringRange] = [
            string.index(string.startIndex, offsetBy: 23)..<string.index(string.startIndex, offsetBy: 32),
            string.index(string.startIndex, offsetBy: 37)..<string.index(string.startIndex, offsetBy: 46),
            string.index(string.startIndex, offsetBy: 86)..<string.index(string.startIndex, offsetBy: 95),
        ]
        
        XCTAssertEqual(chandlerRanges, expectedChandlerRanges)
        
        let carterRanges: [StringRange] = AttributedstringBuilder(text: string).ranges(of: "@carter")
        let expectedCarterRanges: [StringRange] = [
            string.index(string.startIndex, offsetBy: 74)..<string.index(string.startIndex, offsetBy: 81),
        ]
        
        XCTAssertEqual(carterRanges, expectedCarterRanges)
    }

}
