//
//  FeedDataSource.swift
//  ReactiveSwiftDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import UIKit

final class FeedDataSource: NSObject, TwitterClient {

    // MARK: - Properties
    
    private static let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    private(set) var tweets: [Tweet] = []
    
    // MARK: - Public Methods
    
    func fetchTweets(_ completion: @escaping () -> Void) {
        self.searchTweets(query: "iosdev") { (r: Result<[Tweet], Error>) in
            switch r {
            case .success(let tweets):
                self.tweets = tweets
            case .failure(let error):
                fatalError(String(describing: error))
            }
            completion()
        }
    }
    
}
// MARK: - UITableViewDataSource
extension FeedDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let cell as FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) else {
            return UITableViewCell()
        }
        let tweet: Tweet = self.tweets[indexPath.row]
        cell.nameLabel.text = tweet.author.name
        cell.handleLabel.text = tweet.author.handle
        cell.contentLabel.attributedText = tweet.attributedText
        cell.timeElapsedLabel.text = tweet.createdAt.flatMap(type(of: self).dateFormatter.string(from:))
        return cell
    }
    
}
