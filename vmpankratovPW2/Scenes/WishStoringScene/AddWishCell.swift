//
//  AddWoshCell.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 06.11.2024.
//

import UIKit

final class AddWishCell: UITableViewCell, UITextViewDelegate {
    private enum Constants {
        static let textViewRadius: CGFloat = 20
        static let fontSize: CGFloat = 16
        
        static let textViewPlaceholder: String = "Enter your wish..."
        
        static let buttonRadius: CGFloat = 20
        static let buttonTitle: String = "Add Wish"
        
        static let animateDuration: TimeInterval = 0.1
        
        static let wishInputT: CGFloat = 10
        static let wishInputH: CGFloat = 20
        static let wishInputHeight: CGFloat = 80
        
        static let placeholderLabelT: CGFloat = 10
        static let placeholderLabelL: CGFloat = 5
        
        static let addButtonT: CGFloat = 10
        static let addButtonB: CGFloat = 10
        static let addButtonH: CGFloat = 20
    }
    static let reuseId: String = "AddWishCell"
        
    private let wishInputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.addBorder()
        textView.font = .systemFont(ofSize: Constants.fontSize)
        textView.layer.cornerRadius = Constants.textViewRadius
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.textViewPlaceholder
        label.font = .systemFont(ofSize: Constants.fontSize)
        label.textColor = .lightGray
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.fontSize)
        button.backgroundColor = .white
        button.layer.cornerRadius = Constants.buttonRadius
        button.layer.addBorder()
        button.setHeight(40)
        return button
    }()
    
    var addWish: ((String) -> Void)?
    
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
        wishInputTextView.addSubview(placeholderLabel)
        
        wishInputTextView.delegate = self
        
        wishInputTextView.pinTop(to: contentView.topAnchor, Constants.wishInputT)
        wishInputTextView.pinHorizontal(to: contentView, Constants.wishInputH)
        wishInputTextView.setHeight(Constants.wishInputHeight)
        
        
        placeholderLabel.pinTop(to: wishInputTextView.topAnchor, Constants.placeholderLabelT)
        placeholderLabel.pinLeft(to: wishInputTextView.leadingAnchor, Constants.placeholderLabelL)
        
        addButton.pinTop(to: wishInputTextView.bottomAnchor, Constants.addButtonT)
        addButton.pinBottom(to: contentView.bottomAnchor, Constants.addButtonB)
        addButton.pinHorizontal(to: contentView, Constants.addButtonH)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc
    private func addButtonTapped() {
        UIView.animate(withDuration: Constants.animateDuration,
                       animations: {
            self.addButton.alpha = 0.5
        },
                       completion: { _ in
            UIView.animate(withDuration: Constants.animateDuration) {
                self.addButton.alpha = 1.0
            }
        })
        guard var text = wishInputTextView.text, !text.isEmpty else { return }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        addWish?(text)
        wishInputTextView.text = ""
        placeholderLabel.isHidden = false
    }
}
