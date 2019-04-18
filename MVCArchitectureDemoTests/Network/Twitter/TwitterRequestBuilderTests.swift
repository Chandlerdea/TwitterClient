//
//  TwitterRequestBuilderTests.swift
//  MVCArchitectureDemoTests
//
//  Created by Chandler De Angelis on 4/18/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import MVCArchitectureDemo

class TwitterRequestBuilderTests: XCTestCase {

    func testThatSearchRequestIsCorrect() {
        
        let request: URLRequest = TwitterRequestBuilder().search(query: "ios").build()
        
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.url?.absoluteString, "https://api.twitter.com/1.1/search/tweets.json?q=ios")
    }
    
    func testThatShowTweetURLIsCorrect() {
        
        let author: User = User(
            id: 0,
            name: "me",
            handle: "me",
            profileImageUrlString: "http://www.google.com"
        )
        let text: String = "Some text for a tweet"
        let tweet: Tweet = Tweet(
            id: 0,
            text: text,
            userMentions: [],
            author: author,
            createdAt: .none
        )
        
        let request: URLRequest = TwitterRequestBuilder().showTweet(tweet).build()
        
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.url?.absoluteString, "https://api.twitter.com/1.1/statuses/show.json?id=0&tweet_mode=extended")
        
    }

}
