//
//  HTTPMethod.swift
//  ReactiveSwiftDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var validResponseStatuses: [HTTPResponseStatus] {
        switch self {
        case .get:
            return [.ok, .notModified]
        case .post:
            return [.ok, .created]
        case .put:
            return [.ok]
        case .delete:
            return [.noContent]
        }
    }
}

extension URLRequest {
    
    var method: HTTPMethod? {
        get {
            return self.httpMethod.flatMap(HTTPMethod.init(rawValue:))
        }
        set {
            self.httpMethod = newValue?.rawValue
        }
    }
    
}
