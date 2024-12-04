//
//  WishEventCell.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 03.12.2024.
//

import UIKit

final class WishEventCell: UICollectionViewCell {
    static let reuseIdentifier: String = "WishEventCell"
    enum Constants {
        static let wrapRadius: CGFloat = 16
        static let wrapBorderWidth: CGFloat = 1
        
        static let titleFont: UIFont = .boldSystemFont(ofSize: 18)
        static let descriptionFont: UIFont = .systemFont(ofSize: 14)
        static let dateFont: UIFont = .italicSystemFont(ofSize: 12)
        
        static let topPadding: CGFloat = 5
        static let leadingPadding: CGFloat = 10
        static let trailingPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 10
    }
    
    // MARK: - UI Elements
    private let wrapView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.wrapRadius
        view.backgroundColor = .white
        view.layer.borderWidth = Constants.wrapBorderWidth
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.descriptionFont
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.dateFont
        label.textColor = .gray
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.dateFont
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    func configure(with event: WishEvent) {
        titleLabel.text = event.title ?? ""
        descriptionLabel.text = event.eventDescription ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        if let startDate = event.startDate {
            startDateLabel.text = "Start Date: \(dateFormatter.string(from: startDate))"
        } else {
            startDateLabel.text = ""
        }
        
        if let endDate = event.endDate {
            endDateLabel.text = "End Date: \(dateFormatter.string(from: endDate))"
        } else {
            endDateLabel.text = ""
        }
    }
    
    // MARK: - UI Configuration
    private func configureWrap() {
        contentView.addSubview(wrapView)
        wrapView.pinTop(to: contentView.topAnchor, Constants.topPadding)
        wrapView.pinBottom(to: contentView.bottomAnchor, Constants.bottomPadding)
        wrapView.pinLeft(to: contentView.leadingAnchor, Constants.leadingPadding)
        wrapView.pinRight(to: contentView.trailingAnchor, Constants.trailingPadding)
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.pinTop(to: wrapView.topAnchor,  Constants.topPadding)
        titleLabel.pinLeft(to: wrapView.leadingAnchor, Constants.leadingPadding)
        titleLabel.pinRight(to: wrapView.trailingAnchor, Constants.trailingPadding)
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor,  Constants.topPadding)
        descriptionLabel.pinLeft(to: wrapView.leadingAnchor, Constants.leadingPadding)
        descriptionLabel.pinRight(to: wrapView.trailingAnchor, Constants.trailingPadding)
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.pinTop(to: descriptionLabel.bottomAnchor,  Constants.topPadding)
        startDateLabel.pinLeft(to: wrapView.leadingAnchor, Constants.leadingPadding)
        startDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.trailingPadding)
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.pinTop(to: startDateLabel.bottomAnchor,  Constants.topPadding)
        endDateLabel.pinLeft(to: wrapView.leadingAnchor, Constants.leadingPadding)
        endDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.trailingPadding)
        endDateLabel.pinBottom(to: wrapView.bottomAnchor, Constants.bottomPadding)
    }
}
