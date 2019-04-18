//
//  TwitterClientTests.swift
//  TwitterClientTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import TwitterClient

private final class TwitterProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        var contentLength: Int = 0
        if self.request.url?.absoluteString == "https://api.twitter.com/1.1/search/tweets.json?q=iosdev" {
            if let jsonURL: URL = Bundle(for: type(of: self)).url(forResource: "twitter_search_iosdev_response", withExtension: "json"),
                let payload: Data = try? Data(contentsOf: jsonURL) {
                contentLength = payload.count
                self.client?.urlProtocol(self, didLoad: payload)
            }
        } else if request.url?.absoluteString == "https://api.twitter.com/1.1/statuses/show.json?id=1117120457155547136&tweet_mode=extended" {
            if let jsonURL: URL = Bundle(for: type(of: self)).url(forResource: "twitter_show_tweet_response", withExtension: "json"),
                let payload: Data = try? Data(contentsOf: jsonURL) {
                contentLength = payload.count
                self.client?.urlProtocol(self, didLoad: payload)
            }
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
            return
        }
        let response: HTTPURLResponse = HTTPURLResponse(
            url: self.request.url!,
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: [
                "Content-Length": String(describing: contentLength),
                "Content-Type": "application/json; charset=utf-8"
            ]
        )!
        self.client?.urlProtocol(
            self,
            didReceive: response as URLResponse,
            cacheStoragePolicy: .notAllowed
        )
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
}

private final class MockController: TwitterClient {
    
}

class TwitterClientTests: XCTestCase {
    
    private let mockURLSession: URLSession = {
        var config: URLSessionConfiguration = .ephemeral
        config.protocolClasses = [TwitterProtocol.self]
        return URLSession(configuration: config)
    }()

    func testThatTweetsCanBeSearched() {
        let controller: TwitterClient = MockController()
        let exception: XCTestExpectation = self.expectation(description: "fetch tweets")
        controller.searchTweets(query: "iosdev", session: self.mockURLSession) { (r: Result<[Tweet], Error>) in
            switch r {
            case .success(let tweets):
                XCTAssertEqual(tweets.count, 1)
                let tweet: Tweet? = tweets.first
                XCTAssertEqual(tweet?.id, 1118651875044286464)
                XCTAssertEqual(tweet?.text, "RT 100xcode: RT @_swolecat: Just wrapped up Day 46 of #100DaysOfSwift. I\'m having a lot of fun with SpriteKit; I ha… https://t.co/i6s9eDdcno")
                XCTAssertNotNil(tweet?.createdAt)
                
                let user: User? = tweet?.author
                XCTAssertEqual(user?.id, 219109223)
                XCTAssertEqual(user?.handle, "DevAspirerKlaus")
                XCTAssertEqual(user?.profileImageUrlString, "https://pbs.twimg.com/profile_images/1001111843757330432/AHl5HYXx_normal.jpg")
                XCTAssertNotNil(user?.profileImageUrl)
                
                XCTAssertEqual(tweet?.userMentions.count, 1)
                let mention: UserMention? = tweet?.userMentions.first
                XCTAssertEqual(mention?.id, 84176880)
                XCTAssertEqual(mention?.handle, "_swolecat")
                XCTAssertEqual(mention?.name, "koty")
            case .failure(let error):
                XCTFail(String(describing: error))
            }
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 1.0, handler: .none)
    }
    
    func testThatTweetCanBeFetched() {
        let controller: TwitterClient = MockController()
        let exception: XCTestExpectation = self.expectation(description: "fetch tweet")
        let author: User = User(
            id: 242833048,
            name: "Eric Crichlow",
            handle: "MisterEGC",
            profileImageUrlString: "http://pbs.twimg.com/profile_images/1098753234074624000/bbAQD9rh_normal.jpg"
        )
        let tweet: Tweet = Tweet(
            id: 1117120457155547136,
            text: "I'll never understand why so many mobile devs use 3rd party libraries for back end communications.\n\nComplex auth? https://t.co/YTqfmf9aMA",
            userMentions: [],
            author: author,
            createdAt: .none
        )
        controller.fetchExtendedTweet(for: tweet, session: self.mockURLSession) { (r: Result<Tweet, Error>) in
            switch r {
            case .success(let updatedTweet):
                XCTAssertEqual(updatedTweet.id, tweet.id)
                XCTAssertEqual(updatedTweet.fullText, "I’ll never understand why so many mobile devs use 3rd party libraries for back end communications.\n\nComplex auth scheme? Okay. Sure.\n\nBut basic auth?\n\nConnection code is not difficult. Stop importing big (bloated?) libraries to do it.\n\n#iOSDev #AndroidDev")
            case .failure(let error):
                XCTFail(String(describing: error))
            }
            exception.fulfill()
        }
        self.waitForExpectations(timeout: 1.0, handler: .none)
    }

}
