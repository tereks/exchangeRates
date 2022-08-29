//
//  ExchangeRatesData.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

//{
//    "success": true,
//    "base": "GBP",
//    "date": "2022-08-29",
//    "rates": {
//        "EUR": 1.175664,
//        "GBP": 1,
//        "USD": 1.168981
//    }
//}

public struct ExchangeRatesData: Decodable {
    let base: Currency
    let success: Bool
    let rates: [CurrencyRate]

    enum CodingKeys: String, CodingKey {
        case base
        case date
        case rates
        case success
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        base = try values.decode(Currency.self, forKey: .base)
        success = try values.decode(Bool.self, forKey: .success)

        let ratesData = try values.decode(RatesData.self, forKey: .rates)
        var _rates = ratesData.rates
        for i in 0..<_rates.count {
            _rates[i].sellCurrency = base
        }
        rates = _rates
    }
}

public struct RatesData: Decodable {

    let rates: [CurrencyRate]

    private struct DynamicCodingKeys: CodingKey {

        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var _rates: [CurrencyRate] = []

        for key in values.allKeys {
            let rate = try values.decode(Decimal.self, forKey: key)
            let model = CurrencyRate(sellCurrency: Currency(key.stringValue), buyCurrency: Currency(key.stringValue), rate: rate)
            _rates.append(model)
        }
        rates = _rates
    }
}
