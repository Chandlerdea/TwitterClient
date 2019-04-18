//
//  TweetDetailTableViewCell.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/18/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import UIKit

final class TweetDetailTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    private static let imageDiameter: CGFloat = 50
    
    let profileImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        return label
    }()
    
    let handleLabel: UILabel = {
        let label: UILabel = UILabel()
        
        return label
    }()
    
    let tweetTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - Private
private extension TweetDetailTableViewCell {
    
    func createNamesStackViews() -> UIStackView {
        let result: UIStackView = UIStackView()
        result.axis = .vertical
        result.addArrangedSubview(self.usernameLabel)
        result.addArrangedSubview(self.handleLabel)
        return result
    }
    
    func createUserStackView() -> UIStackView {
        let result: UIStackView = UIStackView()
        result.axis = .horizontal
        result.alignment = .center
        result.spacing = UIStackView.spacingUseSystem
        result.addArrangedSubview(self.profileImageView)
        let namesStackView: UIStackView = self.createNamesStackViews()
        result.addArrangedSubview(namesStackView)
        return result
    }
    
    func createParentStackView() -> UIStackView {
        let result: UIStackView = UIStackView()
        result.spacing = UIStackView.spacingUseSystem
        result.translatesAutoresizingMaskIntoConstraints = false
        result.axis = .vertical
        let userStackView: UIStackView = self.createUserStackView()
        result.addArrangedSubview(userStackView)
        result.addArrangedSubview(self.tweetTextLabel)
        result.addArrangedSubview(self.dateLabel)
        return result
    }
    
    func setup() {
        self.selectionStyle = .none
        let stackView: UIStackView = self.createParentStackView()
        self.contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            self.profileImageView.widthAnchor.constraint(equalToConstant: type(of: self).imageDiameter),
            self.profileImageView.heightAnchor.constraint(equalTo: self.profileImageView.widthAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.separatorInset.left),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
}
