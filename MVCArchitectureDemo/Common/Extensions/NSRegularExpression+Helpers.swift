//
//  NSRegularExpression+Helpers.swift
//  ReactiveSwiftDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    
    static let hashtagExpression: NSRegularExpression = try! NSRegularExpression(pattern: "\\B(\\#[a-zA-Z]+\\b)(?!;)")
    
    static let twitterHandleExpression: NSRegularExpression = try! NSRegularExpression(pattern: "^@?(\\w){1,15}$")
    
}
