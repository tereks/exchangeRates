//
//  ExchangeConfigurator.swift
//  exchange
//
//  Created Sergey Kim on 24.08.2022.
//  Copyright © 2022  . All rights reserved.
//

import UIKit

final class ExchangeConfigurator {

    class func create() -> UINavigationController {
        let viewController = ExchangeVC()
        let navigationController = ContentBasedNVC(rootViewController: viewController)

        let presenter = ExchangePresenter(view: viewController)
        let interactor = createInteractor(presenter: presenter)
        viewController.interactor = interactor

        return navigationController
    }

    private class func createInteractor(presenter: ExchangePresenter) -> ExchangeInteractor {
        let dependencies = ExchangeInteractor.Dependencies(presenter: presenter,
                                                           dataProvider: resolve())
        return ExchangeInteractor(dependencies: dependencies)
    }
}
