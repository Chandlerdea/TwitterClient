//
//  FeedTableViewCell.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/17/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import UIKit

final class FeedTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet private(set) var authorImageView: UIImageView!
    @IBOutlet private(set) var nameLabel: UILabel!
    @IBOutlet private(set) var handleLabel: UILabel!
    @IBOutlet private(set) var contentLabel: UILabel!
    @IBOutlet private(set) var timeElapsedLabel: UILabel!

}
