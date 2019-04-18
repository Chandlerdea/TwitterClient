//
//  TweetAttributedStringBuilder.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import UIKit

final class TweetAttributedStringBuilder: AttributedstringBuilder {
    
    // MARK: - Properties
    
    private let mentions: [UserMention]
    
    // MARK: - Init
    
    init?(tweet: Tweet, showsExpanded: Bool) {
        guard let text: String = showsExpanded ? tweet.fullText : tweet.text else {
            return nil
        }
        self.mentions = tweet.userMentions
        super.init(text: text)
    }
    
    // MARK: - Public Methods
    
    func insertMentionAttributes() -> TweetAttributedStringBuilder {
        let result: TweetAttributedStringBuilder = self
        self.mentions.forEach(self.insertAttribute(for:))
        return result
    }
    
    func insertHashtagAttributes() -> TweetAttributedStringBuilder {
        let result: TweetAttributedStringBuilder = self
        
        let range: NSRange = (self.string.startIndex..<self.string.endIndex).makeNSRange(self.string)
        let matches: [NSTextCheckingResult] = NSRegularExpression.hashtagExpression.matches(in: self.string, range: range)
        matches.forEach { (check: NSTextCheckingResult) in
            for index in 0..<check.numberOfRanges {
                let range: NSRange = check.range(at: index)
                let stringRange: StringRange = range.makeStringRange(self.string)
                self.setValue(UIColor.blue, key: .foregroundColor, in: stringRange)
            }
        }
        
        return result
    }
    
    func insertLinkAttributes() -> TweetAttributedStringBuilder {
        let result: TweetAttributedStringBuilder = self
        
        if let detector: NSDataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {
            let range: NSRange = (self.string.startIndex..<self.string.endIndex).makeNSRange(self.string)
            let matches: [NSTextCheckingResult] = detector.matches(in: self.string, range: range)
            matches.forEach { (check: NSTextCheckingResult) in
                for index in 0..<check.numberOfRanges {
                    let range: NSRange = check.range(at: index)
                    let stringRange: StringRange = range.makeStringRange(self.string)
                    self.setValue(UIColor.blue, key: .foregroundColor, in: stringRange)
                }
            }
        }
        
        return result
    }
    
}
// MARK: - Private
private extension TweetAttributedStringBuilder {
    
    func insertAttribute(for mention: UserMention) {
        let ranges: [StringRange] = self.ranges(of: "@\(mention.handle)")
        ranges.forEach { (range: StringRange) in
            self.setValue(UIColor.blue, key: .foregroundColor, in: range)
        }
    }
    
}
