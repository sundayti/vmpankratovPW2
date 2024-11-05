//
//  WrittenWishCell.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 05.11.2024.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    static let reuseId: String = "WrittenWishCell"
    
    private enum Constants {
        static let labelFontSize: CGFloat = 16
        
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 20
        static let wishLabelOffset: CGFloat = 8
    }
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Constants.labelFontSize)
        return label
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
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap: UIView = UIView()
        addSubview(wrap)
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.layer.addBorder()
        
        wrap.pinVertical(to: self, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: self, Constants.wrapOffsetH)
        
        wrap.addSubview(wishLabel)
        wishLabel.pin(to: wrap, Constants.wishLabelOffset)
    }
}
