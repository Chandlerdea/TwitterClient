//
//  UITableView+Helpers.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/18/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCellClasses<T: UITableViewCell>(_ classes: [T.Type]) {
        classes.forEach {
            let identifier = $0.reuseIdentifier
            self.register($0.self, forCellReuseIdentifier: identifier)
        }
    }
    
    func registerCellNibs<T: UITableViewCell>(_ classes: [T.Type]) {
        classes.forEach {
            let name = $0.reuseIdentifier
            let nib = UINib(nibName: name, bundle: Bundle(for: $0))
            self.register(nib, forCellReuseIdentifier: name)
        }
    }
    
    func registerHeaderFooterNibs<T: UITableViewHeaderFooterView>(_ classes: [T.Type]) {
        classes.forEach {
            let bundle: Bundle = Bundle(for: $0)
            let nib: UINib = UINib(nibName: $0.reuseIdentifier, bundle: bundle)
            self.register(nib, forHeaderFooterViewReuseIdentifier: $0.reuseIdentifier)
        }
    }
    
    func registerHeaderFooterClasses<T: UITableViewHeaderFooterView>(_ classes: [T.Type]) {
        classes.forEach {
            self.register($0, forHeaderFooterViewReuseIdentifier: $0.reuseIdentifier)
        }
    }
    
    func dequeue<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        guard case let cell as T = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) else {
            fatalError("Unable to dequeue cell of type \(String(describing: T.self)) with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
    

}
