//
//  Currency.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

public struct Currency: ExpressibleByStringLiteral {

    let code: String

    public init(_ value: String) {
        self.code = value
    }

    public init(stringLiteral value: String) {
        self.code = value
    }

    public var isEmpty: Bool {
        return code.isEmpty
    }
}

extension Currency: Equatable, Hashable {

    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}

extension Currency: Codable {

    public init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        code = try values.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var values = encoder.singleValueContainer()
        try values.encode(code)
    }
}
