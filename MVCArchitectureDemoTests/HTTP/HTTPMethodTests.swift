//
//  HTTPMethodTests.swift
//  MVCArchitectureDemoTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import MVCArchitectureDemo

class HTTPMethodTests: XCTestCase {

    func testValidResponseStatusesAreCorrect() {
        XCTAssertEqual(HTTPMethod.get.validResponseStatuses, [.ok, .notModified])
        XCTAssertEqual(HTTPMethod.post.validResponseStatuses, [.ok, .created])
        XCTAssertEqual(HTTPMethod.put.validResponseStatuses, [.ok])
        XCTAssertEqual(HTTPMethod.delete.validResponseStatuses, [.noContent])
    }
    
    func testThatURLRequestHasCorrectHTTPMethod() {
        var request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        XCTAssertEqual(request.method, .get)
        request.method = .post
        XCTAssertEqual(request.method, .post)
    }

}
