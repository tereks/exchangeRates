//
//  CurrencyRate.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

public struct CurrencyRate {

    var sellCurrency: Currency
    var buyCurrency: Currency
    let rate: Decimal
}

extension CurrencyRate: Equatable {

    public static func == (lhs: CurrencyRate, rhs: CurrencyRate) -> Bool {
        return lhs.sellCurrency == rhs.sellCurrency
        && lhs.buyCurrency == rhs.buyCurrency
    }
}
