//
//  ImageLoader.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import UIKit

typealias ImageLoadHandler = (UIImage?) -> Void

protocol TableImageLoader {
    
    func load(at indexPath: IndexPath, url: URL, handler: @escaping ImageLoadHandler)
    
    func cancelLoad(at indexPath: IndexPath)
    
}

final class ConcreteTableImageLoader: TableImageLoader {
    
    // MARK: - Properties
    
    private var tasks: [IndexPath: URLSessionTask] = [:]
    
    // MARK: - ImageLoader
    
    func load(at indexPath: IndexPath, url: URL, handler: @escaping ImageLoadHandler) {
        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let image: UIImage = data.flatMap(UIImage.init(data:)), error == nil {
                DispatchQueue.main.async {
                    handler(image)
                }
            } else {
                DispatchQueue.main.async {
                    handler(.none)
                }
            }
        }
        self.tasks[indexPath] = task
        task.resume()
    }
    
    func cancelLoad(at indexPath: IndexPath) {
        let task: URLSessionTask? = self.tasks.removeValue(forKey: indexPath)
        task?.cancel()
    }
    
}
