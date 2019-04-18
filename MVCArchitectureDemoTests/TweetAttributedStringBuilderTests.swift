//
//  TweetAttributedStringBuilderTests.swift
//  MVCArchitectureDemoTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import MVCArchitectureDemo

class TweetAttributedStringBuilderTests: XCTestCase {

    func testThatMentionAttributesAreInserted() throws {
        
        let author: User = User(
            id: 0,
            name: "me",
            handle: "me",
            profileImageUrlString: "http://www.google.com"
        )
        let text: String = "A test of handles like @chandler and @chandler, and then another one like @carter and @chandler"
        let tweet: Tweet = Tweet(
            id: 0,
            text: text,
            userMentions: [
                UserMention(
                    id: 0,
                    name: "chandler",
                    handle: "chandler"
                ),
                UserMention(
                    id: 1,
                    name: "carter",
                    handle: "carter"
                )
            ],
            author: author,
            createdAt: .none
        )
        
        let attrString: NSAttributedString? = TweetAttributedStringBuilder(tweet: tweet, showsExpanded: false)?.insertMentionAttributes().build()
        let startIndex: String.Index = text.startIndex
        let mentionRanges: [StringRange] = [
            text.index(startIndex, offsetBy: 23)..<text.index(startIndex, offsetBy: 32),
            text.index(startIndex, offsetBy: 37)..<text.index(startIndex, offsetBy: 46),
            text.index(startIndex, offsetBy: 74)..<text.index(startIndex, offsetBy: 81),
            text.index(startIndex, offsetBy: 86)..<text.index(startIndex, offsetBy: 95),
        ]
        
        for range in mentionRanges {
            let location: Int = text.distance(from: startIndex, to: range.lowerBound)
            var effectiveRange: NSRange = NSRange(location: location, length: text.count)
            let attrs: [NSAttributedString.Key: Any]? = attrString?.attributes(at: location, effectiveRange: &effectiveRange)
            XCTAssertEqual(attrs?[.foregroundColor] as? UIColor, UIColor.blue)
        }

    }
    
    func testThatHashtageAttributesAreInserted() {
        
        let author: User = User(
            id: 0,
            name: "me",
            handle: "me",
            profileImageUrlString: "http://www.google.com"
        )
        let text: String = "Some text for a tweet with some #HasTags and stuff like #MoreHashTags"
        let tweet: Tweet = Tweet(
            id: 0,
            text: text,
            userMentions: [],
            author: author,
            createdAt: .none
        )
        
        let attrString: NSAttributedString? = TweetAttributedStringBuilder(tweet: tweet, showsExpanded: false)?.insertHashtagAttributes().build()
        let startIndex: String.Index = text.startIndex
        let mentionRanges: [StringRange] = [
            text.index(startIndex, offsetBy: 32)..<text.index(startIndex, offsetBy: 40),
            text.index(startIndex, offsetBy: 56)..<text.index(startIndex, offsetBy: 69)
        ]
        
        for range in mentionRanges {
            let location: Int = text.distance(from: startIndex, to: range.lowerBound)
            var effectiveRange: NSRange = NSRange(location: location, length: text.count)
            let attrs: [NSAttributedString.Key: Any]? = attrString?.attributes(at: location, effectiveRange: &effectiveRange)
            XCTAssertEqual(attrs?[.foregroundColor] as? UIColor, UIColor.blue)
        }
    }
    
    func testThatLinkAttributesAreInserted() {
        
        let author: User = User(
            id: 0,
            name: "me",
            handle: "me",
            profileImageUrlString: "http://www.google.com"
        )
        let text: String = "Some text for a tweet with some https://www.google.com links and https://www.google.com"
        let tweet: Tweet = Tweet(
            id: 0,
            text: text,
            userMentions: [],
            author: author,
            createdAt: .none
        )
        
        let attrString: NSAttributedString? = TweetAttributedStringBuilder(tweet: tweet, showsExpanded: false)?.insertLinkAttributes().build()
        let startIndex: String.Index = text.startIndex
        let mentionRanges: [StringRange] = [
            text.index(startIndex, offsetBy: 32)..<text.index(startIndex, offsetBy: 44),
            text.index(startIndex, offsetBy: 65)..<text.index(startIndex, offsetBy: 87)
        ]
        
        for range in mentionRanges {
            let location: Int = text.distance(from: startIndex, to: range.lowerBound)
            var effectiveRange: NSRange = NSRange(location: location, length: text.count)
            let attrs: [NSAttributedString.Key: Any]? = attrString?.attributes(at: location, effectiveRange: &effectiveRange)
            XCTAssertEqual(attrs?[.foregroundColor] as? UIColor, UIColor.blue)
        }
        
    }

}
