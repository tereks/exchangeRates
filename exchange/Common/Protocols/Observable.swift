//
//  Observable.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

public protocol Observable {

    var observations: [UUID: SimpleAction] { get }
}

public extension Dictionary where Key == UUID {

    mutating func insert(_ value: Value) -> UUID {
        let id = UUID()
        self[id] = value
        return id
    }
}
