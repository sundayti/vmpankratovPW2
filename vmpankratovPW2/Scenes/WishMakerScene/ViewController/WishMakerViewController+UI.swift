//
//  WishMakerViewControlle+UI.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 30.10.2024.
//

import UIKit

extension WishMakerViewController {
    
    // MARK: - Interface Configuration
    internal func configureInterfaceView() {
        view.addSubview(interfaceView)
        interfaceView.pinBottom(to: view.bottomAnchor, -Constants.interfaceViewBottom)
        interfaceView.pinHorizontalEdges(to: view)
    }
    
    internal func configureLabelView() {
        view.addSubview(labelView)
        labelView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.labelViewTop)
        labelView.pinHorizontalEdges(to: view)
    }
    
    // MARK: - Title and Description Configuration
    internal func configureTitle() {
        mainTitle.attributedText = createAttributedText(Constants.titleText, fontSize: Constants.titleFontSize)
        labelView.addSubview(mainTitle)
        mainTitle.pinCenterX(to: labelView)
        mainTitle.pinTop(to: labelView.topAnchor)
    }
    
    internal func configureDescription() {
        descriptionLabel.attributedText = createAttributedText(
            Constants.descriptionText,
            fontSize: Constants.descriptionFontSize
        )
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        labelView.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: mainTitle.bottomAnchor, Constants.descriptionTop)
        descriptionLabel.pinHorizontal(to: labelView, Constants.pinHorizontal)
        descriptionLabel.pinBottom(to: labelView.bottomAnchor)
    }
    
    // MARK: - ZStack Configuration
    internal func configureZStack() {
        resetArrangedSubviews(for: colorChangesStack)
        colorChangesStack.configureStackView(axis: .vertical, spacing: Constants.stackSpace, alignment: .fill)
        
        interfaceView.addSubview(colorChangesStack)
        colorChangesStack.pinCenterX(to: interfaceView)
        colorChangesStack.pinHorizontal(to: interfaceView, Constants.pinHorizontal)
        colorChangesStack.pinBottom(to: interfaceView.bottomAnchor)
    }
    
    // MARK: - Slider, Segmented Control, HEX Input, and Random Button Configurations
    internal func configureSlider() {
        let stack = createStackView()
        sliders = createSliders()
        sliders.forEach { stack.addArrangedSubview($0) }
        
        stack.layer.addBorder()
        setupInitialSliderValues(sliders)
        setupSliderActions(sliders)
        colorChangesStack.addArrangedSubview(stack)
    }
    
    internal func configureSegmentedControl() {
        let items = [SegmentedControlConstants.firstTitle, SegmentedControlConstants.secondTitle, SegmentedControlConstants.thirdTitle]
        segmentControl = CustomSegmentedControl(title: Constants.segmentedControlTitle, items: items)
        
        segmentControl.configureSegmentedControl()
        segmentControl.valueChanged = { [weak self] index in self?.handleSegmentChange(index: index) }
        interfaceView.addSubview(segmentControl)
        segmentControl.pinHorizontal(to: interfaceView, Constants.pinHorizontal)
        segmentControl.pinBottom(to: colorChangesStack.topAnchor, Constants.segmentedControlBottom)
    }
    
    internal func configureHEXInput() {
        configureInputField()
        
        let input = CustomInputField(title: InputFieldConstants.title, inputField: inputField)
        input.layer.cornerRadius = Constants.radius
        input.setHeight(InputFieldConstants.height)
        input.layer.addBorder(width: 1, color: .black)
        
        colorChangesStack.addArrangedSubview(input)
        updateHEXInputWithCurrentColor()
    }
    
    private func configureInputField() {
        inputField.placeholder = InputFieldConstants.placeHolder
        inputField.backgroundColor = .white
        inputField.font = .systemFont(ofSize: InputFieldConstants.fontSize)
        inputField.borderStyle = .none
        inputField.delegate = self
    }
    
    internal func configureRandomButton() {
        let button = UIButton(type: .system)
        button.setTitle(Constants.randomButtonTitle, for: .normal)
        button.configureCustomButton(target: self, action: #selector(randomizeColor))
        
        colorChangesStack.addArrangedSubview(button)
    }
    
    internal func configureHideButton() {
        hideButton.setTitle(Constants.hideButtonTitle, for: .normal)
        hideButton.configureCustomButton(target: self, action: #selector(switchValueChanged))
        hideButton.titleLabel?.pinHorizontal(to: hideButton, Constants.pinHorizontal)
        hideButton.titleLabel?.font = .systemFont(ofSize: Constants.descriptionFontSize)
        hideButton.layer.cornerRadius = Constants.hideButtonRadius
        
        interfaceView.addSubview(hideButton)
        hideButton.pinBottom(to: segmentControl.topAnchor, Constants.hideButtonBottom)
        hideButton.pinLeft(to: interfaceView.leadingAnchor, Constants.hideButtonLeft)
        hideButton.pinTop(to: interfaceView.topAnchor)
    }
    
    // MARK: - Helpers and Utility Methods
    private func resetArrangedSubviews(for stack: UIStackView) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func createAttributedText(_ text: String, fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                .strokeColor: UIColor.black,
                .foregroundColor: UIColor.white,
                .strokeWidth: Constants.strokeWidth,
                .font: UIFont.systemFont(ofSize: fontSize)
            ]
        )
    }
    
    internal func updateHEXInputWithCurrentColor() {
        let backgroundColor = view.backgroundColor ?? .white
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        backgroundColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        let hex = UIColor.RGBtoHEX(red, green, blue)
        inputField.text = hex
    }
    
    @objc private func switchValueChanged() {
        isHidden.toggle()
        UIView.animate(withDuration: Constants.animateDuration) {
            self.view.subviews.forEach { $0.alpha = self.isHidden ? 0 : 1 }
        } completion: { _ in
            self.view.subviews.forEach { $0.isHidden = self.isHidden }
        }
    }
    
    @objc private func randomizeColor() {
        let color = UIColor.random()
        UIView.animate(withDuration: Constants.animateDuration) { self.view.backgroundColor = color }
    }
}

// MARK: - Custom Configurations for UI Elements
internal extension UIView {
    func pinHorizontalEdges(to view: UIView) {
        self.pinLeft(to: view.leadingAnchor)
        self.pinRight(to: view.trailingAnchor)
    }
}

private extension CALayer {
    func addBorder(width: CGFloat = 1, color: UIColor = .black) {
        self.borderWidth = width
        self.borderColor = color.cgColor
    }
}

private extension UIStackView {
    func configureStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
    }
}

private extension UIButton {
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

private extension CustomSegmentedControl {
    func configureSegmentedControl() {
        self.layer.addBorder()
        self.layer.cornerRadius = Constants.radius
    }
}
