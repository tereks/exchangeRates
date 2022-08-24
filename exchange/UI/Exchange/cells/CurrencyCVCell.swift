//
//  CurrencyCVCell.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import UIKit

final class CurrencyCVCell: UICollectionViewCell, CellReusable {

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        view.textAlignment = .center
        return view
    }()

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfigure()
        configureLayout()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialConfigure()
        configureLayout()
    }

    // MARK: - Configure

    func initialConfigure() {
        contentView.addSubview(container)
        container.addSubview(titleLabel)
    }

    func configureLayout() {
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
}
