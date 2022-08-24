//
//  ExchangeInteractor.swift
//  exchange
//
//  Created Sergey Kim on 24.08.2022.
//  Copyright © 2022  . All rights reserved.
//

import UIKit

final class ExchangeInteractor {

    // MARK: - Dependencies

    struct Dependencies {
        let presenter: ExchangePresenter
        let dataProvider: RateDataProvider
    }
    private var dip: Dependencies

    private var currencies: [Currency] = ["USD", "EUR", "GBP"]

    // MARK: - Life cycle

    init(dependencies: Dependencies) {
        self.dip = dependencies
    }

    func viewDidLoad() {
        dip.presenter.onViewDidLoad()

    }
}
