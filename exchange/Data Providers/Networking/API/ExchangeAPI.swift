//
//  ExchangeAPI.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation
import Alamofire

public protocol ExchangeAPI {

    @discardableResult
    func getRates(params: [String: String], completion: ((Result<ExchangeRatesData, Error>) -> Void)?) -> DataRequest
}
