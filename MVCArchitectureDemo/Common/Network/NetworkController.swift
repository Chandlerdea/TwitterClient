//
//  NetworkController.swift
//  ReactiveSwiftDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation

protocol NetworkController {
    func sendRequest<T: Decodable>(_ request: URLRequest, _ session: URLSession, completion: @escaping (Result<T, Error>) -> Void)
}

enum ResponseContentError: Error {
    case failureDecodingResponse
}

extension NetworkController {
    
    func handleCompletion(_ request: URLRequest, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<Data, Error> {
        guard let status: HTTPResponseStatus = response?.status else {
            return .failure(BadResponseStatusError.unknownResponseCode)
        }
        guard response?.hasValidResponseStatus(for: request) == true else {
            return .failure(BadResponseStatusError.unexpectedStatus(status))
        }
        if let data: Data = data, error == nil {
            return .success(data)
        } else if let error: Error = error {
            return .failure(error)
        } else {
            fatalError()
        }
    }
    
    func sendRequest<T: Decodable>(_ request: URLRequest, _ session: URLSession = URLSession.shared, completion: @escaping (Result<T, Error>) -> Void) {
        let task: URLSessionTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            let result: Result<Data, Error> = self.handleCompletion(request, data, response, error)
            switch result {
            case .success(let data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let object: T = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(ResponseContentError.failureDecodingResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
