//
//  CellReusable.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation
import UIKit

public protocol CellReusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

public extension CellReusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib? { return nil }
}

public protocol CellReusableFromNib: CellReusable {}

public extension CellReusableFromNib {
    static var nib: UINib? {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

public extension CellReusableFromNib {

    static func loadFromNib(withOwner owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> Self? {
        return nib?.instantiate(withOwner: owner, options: options as? [UINib.OptionsKey: Any]).first as? Self
    }
}

public extension UITableView {

    func register<Cell: UITableViewCell & CellReusable>(_ cell: Cell.Type) {
        if let nib = cell.nib {
            register(nib, forCellReuseIdentifier: Cell.reuseIdentifier)
        } else {
            register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        }
    }

    func dequeueReusableCell<Cell: UITableViewCell & CellReusable>(for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }

    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView & CellReusable>(_: T.Type) {
        if let nib = T.nib {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView & CellReusable>() -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}

public extension UICollectionView {

    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: CellReusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: CellReusable {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

    func registerReusableSupplementaryView<T: CellReusable>(elementKind: String, _: T.Type) {
        if let nib = T.nib {
            self.register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(elementKind: String, indexPath: IndexPath) -> T where T: CellReusable {
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
