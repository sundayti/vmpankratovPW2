//
//  WishCalendarViewController.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 03.12.2024.
//

import UIKit

final class WishCalendarViewController: UIViewController {
    enum Constants {
        static let minimumLayoutSize: CGFloat = 10
        static let minimumLineSpacing: CGFloat = 0
        
        static let controllerViewTop: CGFloat = 10
        static let cellHeight: CGFloat = 120
        static let cellWidth: CGFloat = 20
    }
    
    var currentColor: UIColor = .systemBlue {
        didSet { view.backgroundColor = currentColor }
    }
    
    private var events: [WishEvent] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.minimumLayoutSize
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = currentColor
        configureCollection()
        configureNavigationBar()
        loadEvents()
    }
    
    private func loadEvents() {
        events = WishEventDataManager.shared.loadEvents()
        collectionView.reloadData()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = currentColor
        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )
        view.addSubview(collectionView)
        
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.controllerViewTop)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        collectionView.pinRight(to: view.trailingAnchor)
        collectionView.pinLeft(to: view.leadingAnchor)
    }
    
    @objc private func addButtonTapped() {
        let creationVC = WishEventCreationView()
        creationVC.onSave = { [weak self] in
            self?.loadEvents()
        }
        let navController = UINavigationController(rootViewController: creationVC)
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WishEventCell.reuseIdentifier,
            for: indexPath
        )
        guard let wishEventCell = cell as? WishEventCell else {
            return cell
        }
        let event = events[indexPath.item]
        wishEventCell.configure(with: event)
        return wishEventCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width - Constants.cellWidth,
                      height: Constants.cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let event = events[indexPath.item]
        let editVC = WishEventCreationView()
        editVC.isEditingEvent = true
        editVC.eventToEdit = event
        editVC.onSave = { [weak self] in
            self?.loadEvents()
        }
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true, completion: nil)
    }
}
