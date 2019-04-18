//
//  DetailView.swift
//  ViewControllerKit
//
//  Created by Chandler De Angelis on 4/18/19.
//

import UIKit

final class DetailView: UIView {

    // MARK: - Properties

    let tableView: UITableView = {
        let view: UITableView = UITableView()
        view.tableFooterView = UIView()
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.frame = self.bounds
    }

}
// MARK: - Private Methods
private extension DetailView {

    func setup() {
        self.addSubview(self.tableView)
    }
}
