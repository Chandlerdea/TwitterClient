//
//  HTTPHeaderTests.swift
//  ReactiveSwiftDemoTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import ReactiveSwiftDemo

class HTTPHeaderTests: XCTestCase {

    func testThatNameAndValueIsCorrect() {
        XCTAssertEqual(HTTPHeader.contentType(.json).nameAndValue.0, "Content-Type")
        XCTAssertEqual(HTTPHeader.contentType(.json).nameAndValue.1, "application/json")
    }

}
