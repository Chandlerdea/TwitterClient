//
//  Tweet.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

struct TweetsContainer: Decodable {
    
    let tweets: [Tweet]
    
    enum CodingKeys: String, CodingKey {
        case tweets = "statuses"
    }
}

struct Tweet: Decodable, Equatable {
    
    static func ==(lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "EE MMM d HH:mm:ss Z yyyy"
        return formatter
    }()
    
    let id: Int
    let text: String?
    var fullText: String?
    let userMentions: [UserMention]
    let author: User
    let createdAt: Date?
    
    var attributedText: NSAttributedString? {
        return TweetAttributedStringBuilder(tweet: self)?.insertMentionAttributes()
                                                         .insertHashtagAttributes()
                                                         .insertLinkAttributes()
                                                         .build()
    }
    
    var attributedFullText: NSAttributedString? {
        return self.fullText.flatMap(NSAttributedString.init(string:))
        /*
        return TweetAttributedStringBuilder(tweet: self)?.insertMentionAttributes()
                                                         .insertHashtagAttributes()
                                                         .insertLinkAttributes()
                                                         .build()*/
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case fullText = "full_text"
        case author = "user"
        case createdAtString = "created_at"
        case entities
        case userMentions = "user_mentions"
    }
    
    init(id: Int, text: String, userMentions: [UserMention], author: User, createdAt: Date?) {
        self.id = id
        self.text = text
        self.userMentions = userMentions
        self.author = author
        self.createdAt = createdAt
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.fullText = try container.decodeIfPresent(String.self, forKey: .fullText)
        self.author = try container.decode(User.self, forKey: .author)
        
        let entitiesContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .entities)
        self.userMentions = try entitiesContainer.decode([UserMention].self, forKey: .userMentions)
        
        let createdAtString: String = try container.decode(String.self, forKey: .createdAtString)
        self.createdAt = Tweet.dateFormatter.date(from: createdAtString)
    }
    
}
