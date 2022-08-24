//
//  NetworkConfiguration.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation

public struct NetworkConfig {

    let api: String
}

public class NetworkConfiguration {

    public var baseURLString: String {
        return config.api
    }

    static public let shared: NetworkConfiguration = NetworkConfiguration()

    private let apiConfigKey = "API"
    private var config = NetworkConfig(api: "")

    private init() {
        configure()
    }

    public func configure() {
        config = createConfig()
    }

    func createConfig() -> NetworkConfig {
        let bundle = Bundle(for: NetworkConfiguration.self)
        guard let path = bundle.path(forResource: "Network", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
              let api = dict[apiConfigKey] as? [String: AnyObject] else {
                  assert(false, "NO API configuration")
                  return NetworkConfig(api: "")
              }

        let apiKey: String
        #if DEBUG
        apiKey = "Adhoc"
        #elseif ADHOC
        apiKey = "Adhoc"
        #else
        apiKey = "Release"
        #endif

        guard let config = api[apiKey],
              let url = config["main"] as? String else {
            fatalError("NO API configuration")
        }
        return NetworkConfig(api: url)
    }
}
