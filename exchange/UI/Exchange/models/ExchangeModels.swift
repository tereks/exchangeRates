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
    }

    struct RateViewModel {
        let title: String
    }
}
