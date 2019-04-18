//
//  ReusableViewType.swift
//  MVCArchitectureDemo
//
//  Created by Chandler De Angelis on 4/18/19.
//  Copyright © 2019 Chandlerdea LLC. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableViewType {
    static var reuseIdentifier: String { get }
}

extension ReusableViewType where Self: NSObject {
    static var reuseIdentifier: String {
        let typeString: String = String(describing: self)
        if let decimalIndex: String.Index = typeString.firstIndex(of: ".") {
            return String(typeString[..<decimalIndex])
        } else {
            return typeString
        }
    }
}

extension UITableViewHeaderFooterView: ReusableViewType {}
extension UITableViewCell: ReusableViewType {}
extension UICollectionReusableView: ReusableViewType {}
extension UIViewController: ReusableViewType {}
