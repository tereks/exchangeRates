//
//  AccountDataProvider.swift
//  exchange
//
//  Created by Sergey Kim on 29.08.2022.
//

import Foundation

private enum Key {

    static let balances = "balances"
}

final class AccountDataProvider {

    public var currencyBalances: [Currency: Decimal] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Key.balances) else {
                return [Currency: Decimal]()
            }

            let value = try? JSONDecoder().decode([Currency: Decimal].self, from: data)
            return value ?? [Currency: Decimal]()
        }
        set {
            do {
                let encoded = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey: Key.balances)
            }
            catch {
                debugPrint(error)
            }
        }
    }

    init() {
        let balances: [Currency: Decimal] = ["USD": Decimal(100), "EUR": Decimal(100), "GBP": Decimal(100)]
        if let encoded = try? JSONEncoder().encode(balances) {
            UserDefaults.standard.register(defaults: [Key.balances: encoded])
        }
    }
}
