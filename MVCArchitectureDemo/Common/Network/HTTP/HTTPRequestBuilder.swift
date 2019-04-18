//
//  HTTPRequestBuilder.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

class HTTPRequestBuilder {
    
    // MARK: - Properties
    
    private var components: [String]
    private var queryItems: [URLQueryItem]
    private var body: Data?
    private var headers: [HTTPHeader]
    private var method: HTTPMethod
    private var baseURL: URL
    
    // MARK: - Init
    
    init(baseURL: URL) {
        self.baseURL = baseURL
        self.components = []
        self.queryItems = []
        self.method = .get
        self.headers = [
            .contentType(.json)
        ]
    }
    
    // MARK: - Functions
    
    private func addHeader(_ header: HTTPHeader, to request: URLRequest) -> URLRequest {
        var result: URLRequest = request
        let nameValue: (String, String) = header.nameAndValue
        result.addValue(nameValue.1, forHTTPHeaderField: nameValue.0)
        return result
    }
    
    @discardableResult
    func setMethod(_ method: HTTPMethod) -> HTTPRequestBuilder {
        let result: HTTPRequestBuilder = self
        result.method = method
        return result
    }
    
    @discardableResult
    func setHeader(_ header: HTTPHeader) -> HTTPRequestBuilder {
        let result: HTTPRequestBuilder = self
        if let index: Int = self.headers.firstIndex(where: { $0.nameAndValue.name == header.nameAndValue.name }) {
            result.headers[index] = header
        } else {
            result.headers.append(header)
        }
        return result
    }
    
    @discardableResult
    func setBody(_ body: Data) -> HTTPRequestBuilder {
        let result: HTTPRequestBuilder = self
        result.body = body
        return result
    }
    
    @discardableResult
    func appendPathComponent(_ comp: String) -> HTTPRequestBuilder {
        let result: HTTPRequestBuilder = self
        result.components.append(comp)
        return result
    }
    
    @discardableResult
    func appendQueryItem(name: String, value: String) -> HTTPRequestBuilder {
        let result: HTTPRequestBuilder = self
        let item: URLQueryItem = URLQueryItem(name: name, value: value)
        result.queryItems.append(item)
        return result
    }
    
    func build() -> URLRequest {
        var components: URLComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false)!
        for comp in self.components {
            components.path += "/\(comp)"
        }
        if self.queryItems.isEmpty == false {
            components.queryItems = self.queryItems
        }
        var result: URLRequest = URLRequest(url: components.url!)
        result.httpBody = self.body
        for header in self.headers {
            result = self.addHeader(header, to: result)
        }
        result.httpMethod = self.method.rawValue
        return result
    }
}
