//
//  FeedContainerViewController.swift
//  TwitterClient
//
//  Created by Chandler De Angelis on 4/18/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import UIKit

final class FeedContainerViewController: UIViewController {

    // MARK: - Properties
    
    private let _navigationController: UINavigationController
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let feedViewController: FeedViewController = FeedViewController()
        self._navigationController = UINavigationController(rootViewController: feedViewController)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        feedViewController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationController()
    }
    
}
// MARK: - Private
private extension FeedContainerViewController {
    
    func addNavigationController() {
        self._navigationController.willMove(toParent: self)
        self.addChild(self._navigationController)
        self.view.addSubview(self._navigationController.view)
        self._navigationController.didMove(toParent: self)
    }
    
}
// MARK: - FeedViewDelegate
extension FeedContainerViewController: FeedViewDelegate {
    
    func didSelect(tweet: Tweet, sender: FeedViewController) {
        let detailViewController: DetailViewController = DetailViewController(tweet: tweet)
        self._navigationController.pushViewController(detailViewController, animated: true)
    }
    
}
