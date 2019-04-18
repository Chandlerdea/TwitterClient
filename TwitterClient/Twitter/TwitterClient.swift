//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

protocol TwitterClient: NetworkController {
    
    static var bearerToken: String { get }
    
    func searchTweets(query: String, session: URLSession, completion: @escaping (Result<[Tweet], Error>) -> Void)
    
    func fetchExtendedTweet(for tweet: Tweet, session: URLSession, completion: @escaping (Result<Tweet, Error>) -> Void)
}

extension TwitterClient {
    
    static var bearerToken: String {
        return "AAAAAAAAAAAAAAAAAAAAAJAP%2BAAAAAAATqdsZ3g0xG%2BY3IBD%2FRggv5%2BLXbE%3DRgLkTQcL2DR3Tyvng6UF5ff6eKlPZqIu6kkUufenHS7K5A6qTP"
    }
    
    func searchTweets(query: String, session: URLSession = .shared, completion: @escaping (Result<[Tweet], Error>) -> Void) {
        let token: String = type(of: self).bearerToken
        let request: URLRequest = TwitterRequestBuilder().search(query: query)
                                                         .setAuthorizationToken(token)
                                                         .build()
        self.sendRequest(request, session) { (r: Result<TweetsContainer, Error>) in
            switch r {
            case .success(let container):
                DispatchQueue.main.async {
                    completion(.success(container.tweets))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchExtendedTweet(for tweet: Tweet, session: URLSession = .shared, completion: @escaping (Result<Tweet, Error>) -> Void) {
        let token: String = type(of: self).bearerToken
        let request: URLRequest = TwitterRequestBuilder().showTweet(tweet)
                                                         .setAuthorizationToken(token)
                                                         .build()
        self.sendRequest(request, session) { (r: Result<Tweet, Error>) in
            DispatchQueue.main.async {
                completion(r)
            }
        }
    }
}
