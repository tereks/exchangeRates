//
//  ObservationToken.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

public final class ObservationToken {

    private let cancelClosure: SimpleAction

    public init(cancelClosure: @escaping SimpleAction) {
        self.cancelClosure = cancelClosure
    }

    public func cancel() {
        cancelClosure()
    }
}

public final class IntObservationToken {

    private let cancelClosure: IntAction

    public init(cancelClosure: @escaping IntAction) {
        self.cancelClosure = cancelClosure
    }

    public func cancel() {
        cancelClosure(0)
    }
}
