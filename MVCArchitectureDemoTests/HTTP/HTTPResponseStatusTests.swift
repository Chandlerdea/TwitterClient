//
//  HTTPResponseStatusTests.swift
//  MVCArchitectureDemoTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import MVCArchitectureDemo

class HTTPResponseStatusTests: XCTestCase {

    func testThatHTTPResonseStatueIsCreated() {
        XCTAssertEqual(HTTPResponseStatus(code: 200), .ok)
        XCTAssertEqual(HTTPResponseStatus(code: 201), .created)
        XCTAssertEqual(HTTPResponseStatus(code: 202), .accepted)
        XCTAssertEqual(HTTPResponseStatus(code: 204), .noContent)
        XCTAssertEqual(HTTPResponseStatus(code: 304), .notModified)
        XCTAssertEqual(HTTPResponseStatus(code: 400), .badRequest)
        XCTAssertEqual(HTTPResponseStatus(code: 401), .unauthorized)
        XCTAssertEqual(HTTPResponseStatus(code: 403), .forbidden)
        XCTAssertEqual(HTTPResponseStatus(code: 404), .notFound)
        XCTAssertEqual(HTTPResponseStatus(code: 503), .error(503))
        XCTAssertNil(HTTPResponseStatus(code: 1000))
    }
    
    func testThatCodeIsCorrect() {
        XCTAssertEqual(HTTPResponseStatus.ok.code, 200)
        XCTAssertEqual(HTTPResponseStatus.created.code, 201)
        XCTAssertEqual(HTTPResponseStatus.accepted.code, 202)
        XCTAssertEqual(HTTPResponseStatus.noContent.code, 204)
        XCTAssertEqual(HTTPResponseStatus.notModified.code, 304)
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, 400)
        XCTAssertEqual(HTTPResponseStatus.unauthorized.code, 401)
        XCTAssertEqual(HTTPResponseStatus.forbidden.code, 403)
        XCTAssertEqual(HTTPResponseStatus.notFound.code, 404)
        XCTAssertEqual(HTTPResponseStatus(code: 555)?.code, 555)
    }
    
    func testThatURLResponseStatusIsCorrect() {
        let url: URL = URL(string: "http://www.google.com")!
        
        let getRequest: URLRequest = URLRequest(url: url)
        var postRequest: URLRequest = URLRequest(url: url)
        postRequest.httpMethod = "POST"
        
        let okResponse: URLResponse = HTTPURLResponse(
            url: url,
            statusCode: HTTPResponseStatus.ok.code,
            httpVersion: "1.1",
            headerFields: .none
        )!
        
        let createdResponse: URLResponse = HTTPURLResponse(
            url: url,
            statusCode: HTTPResponseStatus.created.code,
            httpVersion: "1.1",
            headerFields: .none
        )!
        
        XCTAssertEqual(okResponse.status, .ok)
        
        XCTAssertTrue(okResponse.hasValidResponseStatus(for: getRequest))
        XCTAssertFalse(createdResponse.hasValidResponseStatus(for: getRequest))
        XCTAssertTrue(createdResponse.hasValidResponseStatus(for: postRequest))
        
    }

}
