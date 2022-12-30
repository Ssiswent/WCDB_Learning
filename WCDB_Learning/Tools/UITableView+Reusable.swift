//
//  UITableView+Reusable.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/23.
//

import Foundation
import UIKit

extension UITableViewCell: NibLoadableView, ReusableView {}

public protocol ReusableView: class {
    static var reuseIdentifier:String {get}
}

public extension ReusableView where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension ReusableView where Self: UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol NibLoadableView: class {
    static var NibName: String {get}
}

public extension NibLoadableView where Self: UIView {
    static var NibName: String {
        return String(describing: self)
    }
}

public extension UITableView {
    func register<T: UITableViewCell>(_ : T.Type) {
        let cellNib = UINib(nibName: T.NibName, bundle: nil)
        self.register(cellNib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier:  \(T.reuseIdentifier)")
        }
        return cell
    }
}
