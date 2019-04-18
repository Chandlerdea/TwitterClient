//
//  DetailViewController.swift
//  ViewControllerKit
//
//  Created by Chandler De Angelis on 4/18/19.
//

import UIKit

extension DetailViewController {

    final class DataSource: NSObject, UITableViewDataSource, TwitterClient {

        // MARK: - Properties
        
        private static let dateFormatter: DateFormatter = {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "hh:mm a MM/dd/yyyy"
            return formatter
        }()

        weak var viewController: DetailViewController? {
            didSet {
                self.viewController?.tableView.dataSource = self
            }
        }
        
        private(set) var tweet: Tweet
        
        // MARK: - Init
        
        init(tweet: Tweet) {
            self.tweet = tweet
        }
        
        // MARK: - Public Methods
        
        func registerCells(in tableView: UITableView) {
            tableView.registerCellClasses([TweetDetailTableViewCell.self])
        }
        
        func fetchExtendedTweetText(_ completion: @escaping (Result<Void, Error>) -> Void) {
            self.fetchExtendedTweet(for: self.tweet) { (r: Result<Tweet, Error>) in
                switch r {
                case .success(let updatedTweet):
                    self.tweet.fullText = updatedTweet.fullText
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        // MARK: - UITableViewDataSource

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: TweetDetailTableViewCell = tableView.dequeue(at: indexPath)
            cell.usernameLabel.text = self.tweet.author.name
            cell.handleLabel.text = "@\(self.tweet.author.handle)"
            cell.tweetTextLabel.attributedText = self.tweet.attributedFullText ?? self.tweet.attributedText
            cell.dateLabel.text = self.tweet.createdAt.flatMap(type(of: self).dateFormatter.string(from:))
            return cell
        }

    }

}
