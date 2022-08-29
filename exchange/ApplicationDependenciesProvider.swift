//
//  ApplicationDependenciesProvider.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import Foundation
import Dip

let container = DependencyContainer(configBlock: configureContainer)

func configureContainer(container rootContainer: DependencyContainer) {
}

func resolve<T>() -> T {
    return try! container.resolve() as T
}

final class ApplicationDependenceProvider {

    func configure() {
        globalConfigure()
        configureNetworkFactory()
    }

    func configureNetworkFactory() {
        let sessionManager = NetworkFactory.defaultManager(token: resolve())
        container.register(.shared) { NetworkFactory(sessionManager: sessionManager) }
    }

    private func globalConfigure() {
        let dataProvider = container.register(.singleton) { SettingsProvider() }
        container.register(dataProvider, type: AuthorizationToken.self)

        container.register(.shared) { () -> RateDataProvider in
            let dependencies = RateDataProvider.Dependencies(
                networkFactory: resolve(),
                localStorage: resolve()
            )
            return RateDataProvider(dependencies: dependencies)
        }

        container.register(.shared) { TimerService() }

        container.register(.shared) { AccountDataProvider() }
    }
}
