//
//  WishEventCell.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 03.12.2024.
//

import UIKit

final class WishEventCell: UICollectionViewCell {
    static let reuseIdentifier: String = "WishEventCell"
    
    // MARK: - UI Elements
    private let wrapView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 12)
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
        titleLabel.text = event.title ?? "No Title"
        descriptionLabel.text = event.eventDescription ?? "No Description"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        if let startDate = event.startDate {
            startDateLabel.text = "Start Date: \(dateFormatter.string(from: startDate))"
        } else {
            startDateLabel.text = "Start Date: N/A"
        }
        
        if let endDate = event.endDate {
            endDateLabel.text = "End Date: \(dateFormatter.string(from: endDate))"
        } else {
            endDateLabel.text = "End Date: N/A"
        }
    }
    
    // MARK: - UI Configuration
    private func configureWrap() {
        contentView.addSubview(wrapView)
        wrapView.pinTop(to: contentView.topAnchor, 5)
        wrapView.pinBottom(to: contentView.bottomAnchor, 5)
        wrapView.pinLeft(to: contentView.leadingAnchor, 10)
        wrapView.pinRight(to: contentView.trailingAnchor, 10)
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        titleLabel.pinTop(to: wrapView.topAnchor, 5)
        titleLabel.pinLeft(to: wrapView.leadingAnchor, 10)
        titleLabel.pinRight(to: wrapView.trailingAnchor, 10)
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 5)
        descriptionLabel.pinLeft(to: wrapView.leadingAnchor, 10)
        descriptionLabel.pinRight(to: wrapView.trailingAnchor, 10)
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        startDateLabel.pinTop(to: descriptionLabel.bottomAnchor, 5)
        startDateLabel.pinLeft(to: wrapView.leadingAnchor, 10)
        startDateLabel.pinRight(to: wrapView.trailingAnchor, 10)
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        endDateLabel.pinTop(to: startDateLabel.bottomAnchor, 5)
        endDateLabel.pinLeft(to: wrapView.leadingAnchor, 10)
        endDateLabel.pinRight(to: wrapView.trailingAnchor, 10)
        endDateLabel.pinBottom(to: wrapView.bottomAnchor, 10)
    }
}
