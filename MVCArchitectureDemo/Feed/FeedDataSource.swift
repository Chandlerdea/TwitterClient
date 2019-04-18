//
//  FeedDataSource.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import UIKit

final class FeedDataSource: NSObject, TwitterClient {

    // MARK: - Properties
    
    private static let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    private var tweets: [Tweet] = []
    
    // MARK: - Public Methods
    
    func registerCells(with tableView: UITableView) {
        tableView.registerCellNibs([FeedTableViewCell.self])
    }
    
    func fetchTweets(_ completion: @escaping () -> Void) {
        self.searchTweets(query: "#iOSDev") { (r: Result<[Tweet], Error>) in
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
// MARK: - Collection
extension FeedDataSource: Collection {
    
    var startIndex: Int {
        return self.tweets.startIndex
    }
    
    var endIndex: Int {
        return self.tweets.endIndex
    }
    
    subscript(position: Int) -> Tweet {
        get {
            return self.tweets[position]
        }
        set {}
    }
    
    func index(after i: Int) -> Int {
        return self.tweets.index(after: i)
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
        let cell: FeedTableViewCell = tableView.dequeue(at: indexPath)
        let tweet: Tweet = self.tweets[indexPath.row]
        cell.nameLabel.text = tweet.author.name
        cell.handleLabel.text = "@\(tweet.author.handle)"
        cell.contentLabel.attributedText = tweet.attributedText
        cell.timeElapsedLabel.text = tweet.createdAt.flatMap(type(of: self).dateFormatter.string(from:))
        return cell
    }
    
}
