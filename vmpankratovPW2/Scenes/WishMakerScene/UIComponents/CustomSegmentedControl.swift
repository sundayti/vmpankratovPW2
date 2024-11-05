//
//  CustomKeyboardView.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 29.10.2024.
//

import UIKit

final class CustomSegmentedControl: UIView {
    
    // MARK: - Properties
    var valueChanged: ((Int) -> Void)?
    
    private let segmentedControl = UISegmentedControl()
    private var titleView = UILabel()
    
    // MARK: - Initialization
    init(title: String, items: [String]) {
        super.init(frame: .zero)
        titleView.text = title
        titleView.font = .systemFont(ofSize: SegmentedControlConstants.fontSize)
        segmentedControl.insertSegment(withTitle: items[0], at: 0, animated: false)
        for index in 1..<items.count {
            segmentedControl.insertSegment(withTitle: items[index], at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions with segmentedControl
    func removeSegment(at index: Int) {
        guard index <= segmentedControl.numberOfSegments else {
            fatalError("Index out of range")
        }
        segmentedControl.removeSegment(at: index, animated: true)
    }
    
    func insertSegment(withTitle title: String, at index: Int) {
        guard index <= segmentedControl.numberOfSegments else {
            fatalError("Index out of range")
        }
        segmentedControl.insertSegment(withTitle: title, at: index, animated: true)
    }
    
    func setIndex(to index: Int) {
        guard index <= segmentedControl.numberOfSegments else {
            fatalError("Index out of range")
        }
        segmentedControl.selectedSegmentIndex = index
    }
    
    func getIndex() -> Int {
        segmentedControl.selectedSegmentIndex
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(titleView)
        addSubview(segmentedControl)
        
        titleView.pinRight(to: trailingAnchor, SegmentedControlConstants.titleViewRight)
        titleView.pinLeft(to: leadingAnchor, SegmentedControlConstants.titleViewLeft)
        titleView.pinTop(to: topAnchor, SegmentedControlConstants.titleViewTop)
        
        segmentedControl.pinTop(to: titleView.bottomAnchor, SegmentedControlConstants.segmentedControlTop)
        segmentedControl.pinRight(to: trailingAnchor, SegmentedControlConstants.segmentedControlRight)
        segmentedControl.pinLeft(to: leadingAnchor, SegmentedControlConstants.segmentedControlLeft)
        segmentedControl.pinBottom(to: bottomAnchor, SegmentedControlConstants.segmentedControlBottom)
    }
    
    // MARK: - Actions
    @objc
    private func segmentChanged() {
        valueChanged?(segmentedControl.selectedSegmentIndex)
    }
}
