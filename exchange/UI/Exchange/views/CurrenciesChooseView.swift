//
//  CurrenciesChooseView.swift
//  exchange
//
//  Created by Sergey Kim on 24.08.2022.
//

import UIKit

final class CurrenciesChooseView: UIView {

    var currentItemChanged: ((String) -> Void)?

    typealias Cell = CurrencyCVCell

    private let collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    private var items: [String] = []
    private var currentPageIndex = 0

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfigure()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialConfigure()
        configureLayout()
    }

    // MARK: - Actions

    func initialConfigure() {
        clipsToBounds = false
        backgroundColor = .clear

        addSubview(collectionView)

        collectionView.registerReusableCell(Cell.self)
        collectionView.dataSource = self
        collectionView.delegate   = self
    }

    func configureLayout() {
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func setItems(_ items: [String]) {
        self.items = items
    }
}

extension CurrenciesChooseView: UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.title = items[indexPath.item]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
            - collectionView.contentInset.left
            - collectionView.contentInset.right

        let height = collectionView.frame.height
            - collectionView.contentInset.top
            - collectionView.contentInset.bottom
        return CGSize(width: width * 0.95, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width > 0 else {
            return
        }
        let center = convert(collectionView.center, to: collectionView)
        let index = collectionView.indexPathForItem(at: center)?.item ?? 0

        guard currentPageIndex != index else {
            return
        }
        currentItemChanged?(items[index])
        currentPageIndex = index
    }
}
