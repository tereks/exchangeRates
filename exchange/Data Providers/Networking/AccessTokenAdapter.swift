//
//  AccessTokenAdapter.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation
import Alamofire

public final class AccessTokenAdapter: RequestInterceptor {

    let authData: AuthorizationToken

    public init(_ data: AuthorizationToken) {
        self.authData = data
    }

    // MARK: - RequestAdapter implementation

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(name: "apikey", value: authData.token)
        completion(.success(urlRequest))
    }
}
