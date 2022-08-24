//
//  ExchangeGetParameters.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

public struct ExchangeGetParameters: Encodable {

    let base: Currency
    let symbols: [Currency]

    public func encode(to encoder: Encoder) throws {
        var values = encoder.singleValueContainer()
        try values.encode(base)
        try values.encode(symbols)
    }
}
