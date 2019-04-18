//
//  TwitterRequestBuilder.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

final class TwitterRequestBuilder: HTTPRequestBuilder {
    
    convenience init() {
        self.init(baseURL: URL(string: "https://api.twitter.com/1.1")!)
    }
    
    func search(query: String) -> TwitterRequestBuilder {
        let result: TwitterRequestBuilder = self
        result.appendPathComponent("search")
        result.appendPathComponent("tweets.json")
        result.appendQueryItem(name: "q", value: query)
//        result.appendQueryItem(name: "result_type", value: "popluar")
        return result
    }
    
    func showTweet(_ tweet: Tweet) -> TwitterRequestBuilder {
        let result: TwitterRequestBuilder = self
        result.appendPathComponent("statuses")
        result.appendPathComponent("show.json")
        result.appendQueryItem(name: "id", value: String(describing: tweet.id))
        result.appendQueryItem(name: "tweet_mode", value: "extended")
        return result
    }
    
}
