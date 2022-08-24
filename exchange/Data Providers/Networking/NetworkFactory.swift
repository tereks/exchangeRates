//
//  NetworkFactory.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation
import Alamofire

public final class NetworkFactory {

    private let sessionManager: SessionManager

    public init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    public func exchangeAPI() -> ExchangeAPI {
        return ExchangeAPIService(sessionManager: sessionManager)
    }
}

public extension NetworkFactory {

    static func defaultManager(token: AuthorizationToken) -> SessionManager {
        let configuration = URLSessionConfiguration.default
        #if DEBUG
        configuration.timeoutIntervalForRequest  = 20
        configuration.timeoutIntervalForResource = 20
        #else
        configuration.timeoutIntervalForResource = 12
        configuration.timeoutIntervalForRequest  = 12
        #endif
        configuration.urlCredentialStorage = nil
        configuration.requestCachePolicy   = .reloadIgnoringLocalAndRemoteCacheData

        let rootQueue          = DispatchQueue(label: "com.nuts.session.rootQueue", qos: .default)
        let requestQueue       = DispatchQueue(label: "com.nuts.session.requestQueue", qos: .default)
        let serializationQueue = DispatchQueue(label: "com.nuts.session.serializationQueue", qos: .default)
        let accessTokenAdapter = AccessTokenAdapter(token)

        let sessionManager = SessionManager(configuration: configuration,
                                            rootQueue: rootQueue,
                                            startRequestsImmediately: true,
                                            requestQueue: requestQueue,
                                            serializationQueue: serializationQueue,
                                            interceptor: accessTokenAdapter)
        return sessionManager
    }
}
