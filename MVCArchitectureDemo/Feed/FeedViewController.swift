//
//  FeedViewController.swift
//  ReactiveSwiftDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import UIKit

final class FeedViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let dataSource: FeedDataSource = FeedDataSource()
    private let imageLoader: TableImageLoader = ConcreteTableImageLoader()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.fetchTweets()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tweet: Tweet = self.dataSource.tweets[indexPath.row]
        guard case let feedCell as FeedTableViewCell = cell, let imageURL: URL = tweet.author.profileImageUrl else { return }
        self.imageLoader.load(at: indexPath, url: imageURL) { (image: UIImage?) in
            feedCell.authorImageView.image = image
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.imageLoader.cancelLoad(at: indexPath)
    }

}
// MARK: - Private
private extension FeedViewController {
    
    func configureTableView() {
        self.tableView.dataSource = self.dataSource
    }
    
    func fetchTweets() {
        self.dataSource.fetchTweets {
            self.tableView.reloadData()
        }
    }
    
}
