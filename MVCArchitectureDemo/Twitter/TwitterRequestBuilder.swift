//
//  TwitterRequestBuilder.swift
//  ReactiveSwiftDemo
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
        return result
    }
    
}
