//
//  RatesDataProvider.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

final class RateDataProvider {

    struct Dependencies {
        let networkFactory: NetworkFactory
    }
    private(set) var dip: Dependencies

    private lazy var api: ExchangeAPI = {
        return dip.networkFactory.exchangeAPI()
    }()

    // MARK: - Life cycle

    init(dependencies: Dependencies) {
        self.dip = dependencies
    }

    func getRates(for currencies: [Currency], completion: ((Result<[CurrencyRate], Error>) -> Void)?) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.queue.rates")
        var currencyRates: [CurrencyRate] = []
        var lastError: Error?

        for currency in currencies {
            group.enter()
            let params = [
                "base": currency.code,
                "symbols": currencies.map { $0.code }.joined(separator: ",")
            ]
            api.getRates(params: params) { result in
                switch result {
                case .success(let data):
                    queue.sync {
                        currencyRates.append(contentsOf: data.rates)
                    }
                case .failure(let error):
                    queue.sync {
                        lastError = error
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            if let error = lastError {
                completion?(.failure(error))
            }
            else {
                completion?(.success(currencyRates))
            }
        }
    }
}
