//
//  NetworkControllerTests.swift
//  MVCArchitectureDemoTests
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import XCTest
@testable import MVCArchitectureDemo

private struct MockModel: Codable {
    let name: String
}

private final class MockProtocol: URLProtocol {
    
    static var shouldFail: Bool = false

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        var contentLength: Int = 0
        
        if type(of: self).shouldFail {
            let response: HTTPURLResponse = HTTPURLResponse(
                url: self.request.url!,
                statusCode: 404,
                httpVersion: "1.1",
                headerFields: [
                    "Content-Type": "application/json; charset=utf-8"
                ]
            )!
            self.client?.urlProtocol(
                self,
                didReceive: response as URLResponse,
                cacheStoragePolicy: .notAllowed
            )
        } else {
            if let payload: Data = """
            {
                "name": "chandler"
            }
            """.data(using: .utf8) {
                contentLength = payload.count
                self.client?.urlProtocol(self, didLoad: payload)
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
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}

private class MockController: NetworkController {
    
}

class NetworkControllerTests: XCTestCase {

    private let mockURLSession: URLSession = {
        var config: URLSessionConfiguration = .ephemeral
        config.protocolClasses = [MockProtocol.self]
        return URLSession(configuration: config)
    }()

    func testThatRequestSendsSuccessfully() {
        MockProtocol.shouldFail = false
        let controller: NetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "successful request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, self.mockURLSession) { (r: Result<MockModel, Error>) in
            switch r {
            case .success(let model):
                XCTAssertEqual(model.name, "chandler")
            case .failure(let error):
                XCTFail(String(describing: error))
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }
    
    func testThatRequestThrowsError() {
        MockProtocol.shouldFail = true
        let controller: NetworkController = MockController()
        let expectation: XCTestExpectation = self.expectation(description: "unsuccessful request")
        let request: URLRequest = URLRequest(url: URL(string: "http://www.google.com")!)
        controller.sendRequest(request, self.mockURLSession) { (r: Result<MockModel, Error>) in
            switch r {
            case .success:
                XCTFail("exepcted failure")
            case .failure(let error):
                if case BadResponseStatusError.unexpectedStatus(.notFound) = error {
                    break
                } else {
                    XCTFail("unexpected error: \(String(describing: error))")
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: .none)
    }
    
}
