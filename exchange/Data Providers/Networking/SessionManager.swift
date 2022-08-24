//
//  SessionManager.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Alamofire

final public class SessionManager: Session {

    public func loggableRequest(_ convertible: URLRequestConvertible,
                                interceptor: RequestInterceptor? = nil) -> DataRequest {
        return super.request(convertible, interceptor: interceptor)
            .logRequest()
            .validate()
    }

    public func loggableRequestResponse(_ convertible: URLRequestConvertible,
                                        interceptor: RequestInterceptor? = nil) -> DataRequest {
        return super.request(convertible, interceptor: interceptor)
            .logSelf()
            .validate()
    }
}
