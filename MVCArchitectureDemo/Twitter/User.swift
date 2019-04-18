//
//  User.swift
//  ReactiveSwiftDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

struct UserMention: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case handle = "screen_name"
    }
    
    let id: Int
    let name: String
    let handle: String
    
}

struct User: Decodable {
    
    let id: Int
    let name: String
    let handle: String
    let profileImageUrlString: String
    
    var profileImageUrl: URL? {
        return URL(string: profileImageUrlString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case handle = "screen_name"
        case profileImageUrlString = "profile_image_url_https"
    }
}
