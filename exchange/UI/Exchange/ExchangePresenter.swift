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

    private var formatter = NumberFormatter.currencyFormatter

    init(view: ExchangeVC) {
        self.view = view
    }

    func onViewDidLoad() {
        view.initialConfigure()
    }

    func showData(with model: ExchangeModels.DataModel) {
        let viewModel = ExchangeModels.ViewModel(sellItems: model.sellItems.map { $0.code.uppercased() },
                                                 buyItems: model.buyItems.map { $0.code.uppercased() })
        view.display(model: viewModel)
    }

    func showData(with model: ExchangeModels.RateDataModel) {
        let title = String(format: "1 %@ = %@ %@",
                           model.rate.sellCurrency.code,
                           formatter.string(from: model.rate.rate as NSNumber) ?? "",
                           model.rate.buyCurrency.code)
        let balance = String(format: "Current balance: %@ %@",
                             formatter.string(from: model.balance as NSNumber) ?? "",
                             model.rate.sellCurrency.code)
        let viewModel = ExchangeModels.RateViewModel(title: title, balance: balance, buttonEnabled: model.exchangeEnabled)
        view.update(from: viewModel)
    }

    func clear() {
        view.clear()
    }

    func showAlert(title: String, message: String, completion: SimpleAction? = nil) {
        view.showAlert(title: title, message: message, completion: completion)
    }
}
