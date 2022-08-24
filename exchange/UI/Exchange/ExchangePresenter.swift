//
//  ExchangePresenter.swift
//  exchange
//
//  Created Sergey Kim on 24.08.2022.
//  Copyright © 2022  . All rights reserved.
//

import UIKit

final class ExchangePresenter {

    fileprivate(set) weak var view: ExchangeVC!

    init(view: ExchangeVC) {
        self.view = view
    }
}

extension ExchangePresenter {

    func onViewDidLoad() {
        view.initialConfigure()
    }
}
