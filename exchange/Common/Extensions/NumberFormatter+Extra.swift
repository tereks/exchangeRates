//
//  NumberFormatter+Extra.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

extension NumberFormatter {

    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.generatesDecimalNumbers = false
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale.autoupdatingCurrent
        formatter.currencySymbol = ""
        formatter.groupingSeparator = ""
        return formatter
    }()
}
