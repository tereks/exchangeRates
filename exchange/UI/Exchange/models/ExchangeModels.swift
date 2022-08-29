//
//  ExchangeModels.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

enum ExchangeModels {

    struct ViewModel {
        let sellItems: [String]
        let buyItems: [String]
    }

    struct DataModel {
        let sellItems: [Currency]
        let buyItems: [Currency]
    }


    struct RateDataModel {
        let rate: CurrencyRate
        let balance: Decimal
        let exchangeEnabled: Bool
    }

    struct RateViewModel {
        let title: String
        let balance: String
        let buttonEnabled: Bool
    }
}
