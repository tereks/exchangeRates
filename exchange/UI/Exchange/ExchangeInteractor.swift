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
        let timer: TimerService
    }
    private var dip: Dependencies

    private var currencies: [Currency] = ["USD", "EUR", "GBP"]
    private var currentCurrencyRate = CurrencyRate(sellCurrency: "USD", buyCurrency: "USD", rate: 0) {
        didSet {
            onCurrentCurrencyPairChanged()
        }
    }
    private var currencyRates: [CurrencyRate] = []

    // MARK: - Life cycle

    init(dependencies: Dependencies) {
        self.dip = dependencies
    }

    func viewDidLoad() {
        dip.presenter.onViewDidLoad()

        let dataModel = ExchangeModels.DataModel(sellItems: currencies, buyItems: currencies)
        dip.presenter.showData(with: dataModel)

        loadData()
    }

    func sellCurrencyChanged(_ code: String) {
        currentCurrencyRate.sellCurrency = Currency(code)
    }

    func buyCurrencyChanged(_ code: String) {
        currentCurrencyRate.buyCurrency = Currency(code)
    }

    private func onCurrentCurrencyPairChanged() {
        guard let index = currencyRates.firstIndex(of: currentCurrencyRate) else {
            debugPrint("No rates found")
            return
        }
        let dataModel = ExchangeModels.RateDataModel(rate: currencyRates[index])
        dip.presenter.showData(with: dataModel)
    }

    private func loadData() {
        dip.dataProvider.getRates(for: currencies) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let rates):
                self.currencyRates = rates
                self.onCurrentCurrencyPairChanged()
            case .failure(let error):
                // disable UI
                debugPrint(error.localizedDescription)
            }
        }
    }
}
