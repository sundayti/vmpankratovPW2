//
//  AddWoshCell.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 06.11.2024.
//
import UIKit

final class AddWishCell: UITableViewCell {
    static let reuseId: String = "AddWishCell"
    
    var addWish: ((String) -> Void)?
    
    private let wishInputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Wish", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(wishInputTextView)
        contentView.addSubview(addButton)
        
        wishInputTextView.pinTop(to: contentView.topAnchor, 8)
        wishInputTextView.pinLeft(to: contentView.leadingAnchor, 16)
        wishInputTextView.pinRight(to: contentView.trailingAnchor, 16)
        wishInputTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        addButton.pinTop(to: wishInputTextView.bottomAnchor, 8)
        addButton.pinBottom(to: contentView.bottomAnchor, 8)
        addButton.pinLeft(to: contentView.leadingAnchor, 16)
        addButton.pinRight(to: contentView.trailingAnchor, 16)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }


    
    @objc private func addButtonTapped() {
        guard let text = wishInputTextView.text, !text.isEmpty else { return }
        addWish?(text) // Trigger the closure
        wishInputTextView.text = "" // Clear text after adding
    }
}

