//
//  WishStoringViewController.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 05.11.2024.
//
import UIKit

final class WishStoringViewController: UIViewController {
    private enum Constants {
        static let radius: CGFloat = 16
        static let numerOfSections: Int = 2
        
        static let editTitle: String = "Edit"
        static let deleteTitle: String = "Delete"
        static let shareTitle: String = "Share"
        static let saveTitle: String = "Save"
        static let cancelTitle: String = "Cancel"
    }
    
    private let table: UITableView = UITableView(frame: .zero)
    private var wishArray: [Wish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWishes()
        configureUI()
    }
    
    private func loadWishes() {
        wishArray = WishDataManager.shared.loadWishes()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemPink
        configureTable()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .systemPink
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.radius
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        
        table.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor)
        table.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor)
        table.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        table.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func addWish(_ text: String) {
        WishDataManager.shared.addWish(text: text)
        loadWishes()
        table.reloadData()
    }
    
    private func deleteWish(at index: Int) {
        let wishToDelete = wishArray[index]
        WishDataManager.shared.deleteWish(wishToDelete)
        loadWishes()
        table.reloadData()
    }
    
    private func editWish(at index: Int, newText: String) {
        let wishToEdit = wishArray[index]
        WishDataManager.shared.editWish(wishToEdit, newText: newText)
        loadWishes()
        table.reloadData()
    }
    
    private func shareWish(_ text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

extension WishStoringViewController {
    private func showEditAlert(at index: Int) {
        let alertController = UIAlertController(title: Constants.editTitle, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.wishArray[index].text
        }
        
        let saveAction = UIAlertAction(title: Constants.saveTitle, style: .default) { _ in
            if let newText = alertController.textFields?.first?.text, !newText.isEmpty {
                self.editWish(at: index, newText: newText)
            }
        }
        alertController.addAction(saveAction)
        alertController.addAction(UIAlertAction(title: Constants.cancelTitle, style: .cancel))
        
        present(alertController, animated: true)
    }
}

extension WishStoringViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : wishArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as? AddWishCell else {
                return UITableViewCell()
            }
            addCell.addWish = { [weak self] newWish in
                self?.addWish(newWish)
            }
            return addCell
        } else {
            guard let wishCell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as? WrittenWishCell else {
                return UITableViewCell()
            }
            let wish = wishArray[indexPath.row]
            wishCell.configure(with: wish.text ?? "")
            return wishCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numerOfSections
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: Constants.deleteTitle)
        { [weak self] _, _, completionHandler in
            self?.deleteWish(at: indexPath.row)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        
        let editAction = UIContextualAction(style: .normal, title: Constants.editTitle)
        { [weak self] _, _, completionHandler in
            self?.showEditAlert(at: indexPath.row)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemGreen
        
        let shareAction = UIContextualAction(style: .normal, title: Constants.shareTitle)
        { [weak self] _, _, completionHandler in
            self?.shareWish(self?.wishArray[indexPath.row].text ?? "")
            completionHandler(true)
        }
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [shareAction, editAction])
    }
}
