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
    private lazy var currencyBalances: [Currency: Decimal] = dip.dataProvider.currencyBalances

    private var timerToken: ObservationToken?
    private var maxValue: Decimal {
        return currencyBalances[currentCurrencyRate.sellCurrency] ?? 0
    }

    // MARK: - Life cycle

    deinit {
        timerToken?.cancel()
    }

    init(dependencies: Dependencies) {
        self.dip = dependencies
    }

    func viewDidLoad() {
        dip.presenter.onViewDidLoad()

        let dataModel = ExchangeModels.DataModel(sellItems: currencies, buyItems: currencies)
        dip.presenter.showData(with: dataModel)

        configureTimer()
        loadData()
    }

    func viewDidAppear() {
        dip.timer.start(updateInterval: 30, lastUpdateDate: Date())
    }

    func viewWillDisappear() {
        dip.timer.reset()
    }

    private func configureTimer() {
        dip.timer.observeChange { [unowned self] in
            self.loadData()
        }
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

        let rate      = currencyRates[index]
        let balance   = currencyBalances[rate.sellCurrency] ?? 0
        let exchangeEnabled = balance > 0 && rate.sellCurrency != rate.buyCurrency
        let dataModel = ExchangeModels.RateDataModel(rate: rate,
                                                     balance: balance,
                                                     exchangeEnabled: exchangeEnabled)
        dip.presenter.showData(with: dataModel)
    }

    private func loadData() {
        dip.dataProvider.getRates(for: currencies) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let rates):
                self.currencyRates = rates
                self.onCurrentCurrencyPairChanged()
                self.dip.timer.start(updateInterval: 30, lastUpdateDate: Date())
            case .failure(let error):
                // disable UI
                debugPrint(error.localizedDescription)
            }
        }
    }

    func buttonSelected(_ amountString: String) {
        let amount = Decimal(string: amountString) ?? 0
        guard let sellBalance = currencyBalances[currentCurrencyRate.sellCurrency],
              let buyBalance = currencyBalances[currentCurrencyRate.buyCurrency] else {
            return
        }
        currencyBalances[currentCurrencyRate.sellCurrency] = sellBalance - amount
        currencyBalances[currentCurrencyRate.buyCurrency]  = buyBalance + amount

        onCurrentCurrencyPairChanged()
        dip.presenter.clear()
        dip.presenter.showAlert(title: "Обмен валюты", message: "Операция прошла успешно")
    }

    // UITextField Delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {
            return false
        }

        let textAfterUpdate = text.replacingCharacters(in: range, with: string)
        guard fractionDigitsCount(in: textAfterUpdate) <= 2 else {
            return false
        }

        let newValue = Decimal(string: textAfterUpdate) ?? 0
        return newValue <= maxValue
    }

    private func fractionDigitsCount(in string: String) -> Int {
        var commaIndex = string.firstIndex(of: ".")?.utf16Offset(in: string)
        if commaIndex == nil {
            commaIndex = string.firstIndex(of: ",")?.utf16Offset(in: string)
        }
        guard let commaIndex = commaIndex else {
            return 0
        }
        return string.count - 1 - commaIndex
    }
}
