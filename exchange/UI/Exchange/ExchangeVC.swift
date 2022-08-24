//
//  ExchangeVC.swift
//  exchange
//
//  Created Sergey Kim on 24.08.2022.
//  Copyright © 2022  . All rights reserved.
//

import UIKit

final class ExchangeVC: UIViewController {

    // MARK: - Dependencies

    var interactor: ExchangeInteractor!

    // MARK: - Properties

    // MARK: - Life cycle

	override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }

    func initialConfigure() {
        view.backgroundColor = .yellow
        configureLayout()
    }

    private func configureLayout() {
    }
}
