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

    static let inputHeight: CGFloat = 50
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
        view.textColor = .summerRed
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

    let balanceLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .summerRed
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()

    let currencyInput: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .none
        view.backgroundColor = .beidge
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        view.tintColor = .fall
        view.keyboardType = .decimalPad
        view.returnKeyType = .done
        return view
    }()

    let button: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Exchange it", for: .normal)
        view.clipsToBounds = true

        view.setTitleColor(UIColor(rgb: 0x483838), for: .normal)
        view.setTitleColor(UIColor.black, for: .highlighted)
        view.setTitleColor(UIColor.black, for: .selected)
        view.setTitleColor(UIColor.black, for: .disabled)

        view.setBackgroundImage(UIColor(rgb: 0xB1D7B4).image(), for: .normal)
        view.setBackgroundImage(UIColor(rgb: 0xB1D7B4).image(), for: .highlighted)
        view.setBackgroundImage(UIColor(rgb: 0xB1D7B4).image(), for: .selected)
        view.setBackgroundImage(UIColor.gray.image(), for: .disabled)

        view.layer.cornerRadius = 8
        view.isEnabled = false
        return view
    }()

    // MARK: - Life cycle

    deinit {
        NotificationCenter.default.removeObserver(self)        
    }

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
        view.backgroundColor = .mintGreen

        view.addSubview(rateLabel)
        view.addSubview(currencyChoose1View)
        view.addSubview(titleLabel)
        view.addSubview(currencyChoose2View)
        view.addSubview(balanceLabel)
        view.addSubview(currencyInput)
        view.addSubview(button)

        currencyInput.delegate = self

        configureActions()
        configureLayout()

        button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

        balanceLabel.topAnchor.constraint(equalTo: currencyChoose2View.bottomAnchor, constant: Constants.insets.top).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insets.left).isActive = true
        balanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insets.right).isActive = true

        currencyInput.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: Constants.insets.top).isActive = true
        currencyInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insets.left).isActive = true
        currencyInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insets.right).isActive = true
        currencyInput.heightAnchor.constraint(equalToConstant: Constants.inputHeight).isActive = true

        button.topAnchor.constraint(equalTo: currencyInput.bottomAnchor, constant: Constants.insets.top).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.insets.left).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.insets.right).isActive = true
        button.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    }

    private func configureActions() {
        currencyChoose1View.currentItemChanged = { [unowned self] code in
            self.interactor.sellCurrencyChanged(code)
        }
        currencyChoose2View.currentItemChanged = { [unowned self] code in
            self.interactor.buyCurrencyChanged(code)
        }
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            let freeSpace = view.bounds.height - button.frame.maxY - 20
            if freeSpace < keyboardHeight {
                setViewOffset(freeSpace - keyboardHeight)
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        setViewOffset(0)
    }

    @objc func buttonSelected() {
        interactor.buttonSelected(currencyInput.text ?? "")
    }

    func display(model: ExchangeModels.ViewModel) {
        currencyChoose1View.setItems(model.sellItems)
        currencyChoose2View.setItems(model.buyItems)
    }

    func update(from model: ExchangeModels.RateViewModel) {
        rateLabel.text    = model.title
        balanceLabel.text = model.balance
        button.isEnabled  = model.buttonEnabled
    }

    func clear() {
        currencyInput.text = nil
        currencyInput.resignFirstResponder()
    }

    func setViewOffset(_ offset: CGFloat) {
        if offset > 0 {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= offset
            }
        }
        else {
            if view.frame.origin.y != 0 {
                view.frame.origin.y = 0
            }
        }
    }

    func showAlert(title: String, message: String, completion: SimpleAction?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension ExchangeVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return interactor.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
