//
//  ImageDisplayable.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/18/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDisplayableCompletion = (Result<UIImage, Error>) -> Void

enum ImageDisplayableError: Error {
    case unexpectedMimeType
    case unableToCreateImage
    case unknown
}

protocol ImageDisplayable {
    
    var imageSession: URLSession { get set }
    
    var expectedMimeTypes: [String] { get }
    
    func download(at url: URL, completion: @escaping ImageDisplayableCompletion) -> Int
    
    func cancelDownloading(at url: URL)
}

extension ImageDisplayable {
    
    var expectedMimeTypes: [String] {
        return [
            "image/png",
            "image/jpeg"
        ]
    }
    
    @discardableResult
    func download(at url: URL, completion: @escaping ImageDisplayableCompletion) -> Int {
        func asyncComp(_ result: Result<UIImage, Error>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task: URLSessionTask = self.imageSession.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let mimeType: String = response?.mimeType, self.expectedMimeTypes.contains(mimeType) == false {
                asyncComp(.failure(ImageDisplayableError.unexpectedMimeType))
            } else if let unwrappedData: Data = data, error == nil {
                if let image: UIImage = UIImage(data: unwrappedData) {
                    asyncComp(.success(image))
                } else {
                    asyncComp(.failure(ImageDisplayableError.unableToCreateImage))
                }
            } else if let unwrappedError: Error = error {
                asyncComp(.failure(unwrappedError))
            } else {
                asyncComp(.failure(ImageDisplayableError.unknown))
            }
        }
        task.resume()
        return task.taskIdentifier
    }

}
