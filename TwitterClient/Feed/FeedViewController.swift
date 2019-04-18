//
//  FeedViewController.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import UIKit

protocol FeedViewDelegate: class {
    func didSelect(tweet: Tweet, sender: FeedViewController)
}

final class FeedViewController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: FeedViewDelegate?
    
    private let dataSource: FeedDataSource = FeedDataSource()
    private let imageLoader: TableImageLoader = ConcreteTableImageLoader()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigaitonItem()
        self.configureTableView()
        self.fetchTweets()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tweet: Tweet = self.dataSource[indexPath.row]
        self.delegate?.didSelect(tweet: tweet, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tweet: Tweet = self.dataSource[indexPath.row]
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
    
    func configureNavigaitonItem() {
        self.title = "Feed"
    }
    
    func configureTableView() {
        self.tableView.dataSource = self.dataSource
        self.dataSource.registerCells(with: self.tableView)
    }
    
    func fetchTweets() {
        self.dataSource.fetchTweets {
            self.tableView.reloadData()
        }
    }
    
}
