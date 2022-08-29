//
//  ExchangeRequest.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Alamofire

enum ExchangeRequest: URLRequestConvertible {

    case rates(parameters: [String: String])

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .rates:
            return "/latest"
        }
    }

    private static var urlEncoder: URLEncodedFormParameterEncoder = {
        var formEncoder = URLEncodedFormEncoder(arrayEncoding: .noBrackets,
                                                boolEncoding: .literal,
                                                keyEncoding: .convertToSnakeCase)
        let encoder = URLEncodedFormParameterEncoder(encoder: formEncoder, destination: .methodDependent)
        return encoder
    }()

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let url = try NetworkConfiguration.shared.baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .rates(let parameters):
            urlRequest = try ExchangeRequest.urlEncoder.encode(parameters, into: urlRequest)
        }
        return urlRequest
    }
}
