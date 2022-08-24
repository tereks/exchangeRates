//
//  DataRequest+Log.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation
import Alamofire

public extension DataRequest {

    func logSelf() -> Self {
        return response { response in
            guard let code = response.response?.statusCode,
                let path = response.request?.url?.absoluteString else {
                    return
            }
            var text = "\nResponse code=\(code)"
            text.append("\nPath: \"\(path)\"")
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                text.append("\nData: \"\(body)\"")
            }
            self.cURLDescription { curl in
                debugPrint("\n\(curl)")
                debugPrint(text.removingPercentEncoding ?? text)
            }
        }
    }

    // MARK: - Request logging

    func logRequest() -> Self {
        cURLDescription { curl in
            let text = curl.replacingOccurrences(of: "\\\n\t", with: "")
            debugPrint("\n\(text)")
        }
        return self
    }

    // MARK: - Response logging

    func logResponse() -> Self {
        return response { response in
            guard let code = response.response?.statusCode,
                let path = response.request?.url?.absoluteString else {
                    return
            }
            var text = "\nResponse code=\(code)"
            text.append("\nPath: \"\(path)\"")
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                text.append("\nData: \"\(body)\"")
            }
            debugPrint(text.removingPercentEncoding ?? text)
        }
    }
}
