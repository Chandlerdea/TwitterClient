//
//  DetailView.swift
//  ViewControllerKit
//
//  Created by Chandler De Angelis on 4/18/19.
//

import UIKit

final class DetailViewController: UIViewController {

    // MARK: - Properties

    private let dataSource: DataSource
    private let _view: DetailView = DetailView()
    private let imageLoader: TableImageLoader = ConcreteTableImageLoader()

    var tableView: UITableView {
        return self._view.tableView
    }

    // MARK: - Init

    init(tweet: Tweet) {
        self.dataSource = DataSource(tweet: tweet)
        super.init(nibName: .none, bundle: .none)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        self.view = self._view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationItem()
        self.configureTableView()
        self.fetchExtendedTweet()
    }
}
// MARK: - Private
private extension DetailViewController {
    
    func configureNavigationItem() {
        self.title = "Tweet"
    }
    
    func configureTableView() {
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.dataSource.registerCells(in: self.tableView)
        self.dataSource.viewController = self
    }
    
    func fetchExtendedTweet() {
        self.dataSource.fetchExtendedTweetText { (r: Result<Void, Error>) in
            self.tableView.reloadData()
        }
    }
    
}
// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let detailCell as TweetDetailTableViewCell = cell, let url: URL = self.dataSource.tweet.author.profileImageUrl else { return }
        self.imageLoader.load(at: indexPath, url: url) { (image: UIImage?) in
            detailCell.profileImageView.image = image
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.imageLoader.cancelLoad(at: indexPath)
    }
    
}
