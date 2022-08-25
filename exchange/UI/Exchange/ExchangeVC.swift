//
//  ExchangeVC.swift
//  exchange
//
//  Created Sergey Kim on 24.08.2022.
//  Copyright © 2022  . All rights reserved.
//

import UIKit

private enum Constants {

    static let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    static let height: CGFloat = 56
}

final class ExchangeVC: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Dependencies

    var interactor: ExchangeInteractor!

    // MARK: - Properties

    let rateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return view
    }()

    let currencyChoose1View: CurrenciesChooseView = {
        let view = CurrenciesChooseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        view.text = "↓"
        return view
    }()

    let currencyChoose2View: CurrenciesChooseView = {
        let view = CurrenciesChooseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Life cycle

	override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.viewWillDisappear()
    }

    func initialConfigure() {
        view.backgroundColor = .lightGray

        view.addSubview(rateLabel)
        view.addSubview(currencyChoose1View)
        view.addSubview(titleLabel)
        view.addSubview(currencyChoose2View)

        configureActions()
        configureLayout()
    }
    
    private func configureLayout() {
        let guide = view.safeAreaLayoutGuide

        rateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insets.left).isActive = true
        rateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insets.right).isActive = true
        rateLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: Constants.insets.top).isActive = true

        currencyChoose1View.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insets.left).isActive = true
        currencyChoose1View.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insets.right).isActive = true
        currencyChoose1View.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: Constants.insets.top).isActive = true
        currencyChoose1View.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true

        titleLabel.topAnchor.constraint(equalTo: currencyChoose1View.bottomAnchor, constant: Constants.insets.top).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insets.left).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insets.right).isActive = true

        currencyChoose2View.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.insets.top).isActive = true
        currencyChoose2View.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insets.left).isActive = true
        currencyChoose2View.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insets.right).isActive = true
        currencyChoose2View.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    }

    private func configureActions() {
        currencyChoose1View.currentItemChanged = { [unowned self] code in
            self.interactor.sellCurrencyChanged(code)
        }
        currencyChoose2View.currentItemChanged = { [unowned self] code in
            self.interactor.buyCurrencyChanged(code)
        }
    }

    func display(model: ExchangeModels.ViewModel) {
        currencyChoose1View.setItems(model.sellItems)
        currencyChoose2View.setItems(model.buyItems)
    }

    func update(from model: ExchangeModels.RateViewModel) {
        rateLabel.text = model.title
    }
}
