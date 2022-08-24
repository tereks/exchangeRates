//
//  ExchangeAPIService.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation
import Alamofire

public final class ExchangeAPIService: ExchangeAPI {

    let sessionManager: SessionManager
    private var currentRequest: Request?

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    public init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    public func cancel() {
        currentRequest?.cancel()
    }

    public func getRates(params: [String: String], completion: ((Result<ExchangeRatesData, Error>) -> Void)?) -> DataRequest {
        return sessionManager.loggableRequest(ExchangeRequest.rates(parameters: params))
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let result = Result {
                        try JSONDecoder().decode(ExchangeRatesData.self, from: data)
                    }
                    completion?(result)
                case .failure(let error):
                    completion?(.failure(error))
                }
        }
    }
}
