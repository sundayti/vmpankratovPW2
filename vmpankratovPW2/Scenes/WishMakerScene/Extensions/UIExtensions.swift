//
//  UIExtensions.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 05.11.2024.
//

import UIKit

// MARK: - Custom Configurations for UI Elements
extension UIView {
    func pinHorizontalEdges(to view: UIView) {
        self.pinLeft(to: view.leadingAnchor)
        self.pinRight(to: view.trailingAnchor)
    }
}

extension CALayer {
    func addBorder(width: CGFloat = 1, color: UIColor = .black) {
        self.borderWidth = width
        self.borderColor = color.cgColor
    }
}

extension UIStackView {
    func configureStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
    }
}

extension UIButton {
    func configureCustomButton(target: Any?, action: Selector) {
        self.backgroundColor = .white
        self.layer.addBorder()
        self.layer.cornerRadius = Constants.radius
        self.titleLabel?.font = .systemFont(ofSize: Constants.buttonTextFontSize)
        self.setTitleColor(.black, for: .normal)
        self.setHeight(Constants.buttonHeight)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension CustomSegmentedControl {
    func configureSegmentedControl() {
        self.layer.addBorder()
        self.layer.cornerRadius = Constants.radius
    }
}
