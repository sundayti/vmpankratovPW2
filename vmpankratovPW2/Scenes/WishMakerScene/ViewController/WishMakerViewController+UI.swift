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
        interfaceView.pinBottom(to: actionStack.topAnchor, -Constants.interfaceViewBottom)
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
    
    // MARK: - ColorChangesStack Configuration
    internal func configureColorChangesStack() {
        resetArrangedSubviews(for: colorChangesStack)
        colorChangesStack.configureStackView(axis: .vertical, spacing: Constants.stackSpace, alignment: .fill)
        
        interfaceView.addSubview(colorChangesStack)
        colorChangesStack.pinCenterX(to: interfaceView)
        colorChangesStack.pinHorizontal(to: interfaceView, Constants.pinHorizontal)
        colorChangesStack.pinBottom(to: interfaceView.bottomAnchor)
    }
    
    // MARK: - Slider, Segmented Control, HEX Input, and Random Button Configurations
    internal func configureAddWishButton() {
        addWishButton.setHeight(Constants.buttonHeight)
        
        addWishButton.backgroundColor = .white
        addWishButton.setTitle(Constants.addButtonTitle, for: .normal)
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.layer.addBorder()
        addWishButton.layer.cornerRadius = Constants.radius
        addWishButton.titleLabel?.font = .systemFont(ofSize: Constants.buttonTextFontSize)
        
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    internal func configureActionStack() {
        actionStack.axis = .vertical
        view.addSubview(actionStack)
        actionStack.spacing = Constants.stackSpace
        for button in [addWishButton, scheduleWishesButton] {
        actionStack.addArrangedSubview(button)
        }
        configureAddWishButton()
        configureSheduleMission()
        actionStack.pinBottom(to: view, Constants.stackBottom)
        actionStack.pinHorizontal(to: view, Constants.stackLeading)
    }
    
    internal func configureSheduleMission() {
        scheduleWishesButton.setHeight(Constants.buttonHeight)
        
        scheduleWishesButton.backgroundColor = .white
        scheduleWishesButton.setTitle("Ygab", for: .normal)
        scheduleWishesButton.setTitleColor(.systemPink, for: .normal)
        scheduleWishesButton.layer.addBorder()
        scheduleWishesButton.layer.cornerRadius = Constants.radius
        scheduleWishesButton.titleLabel?.font = .systemFont(ofSize: Constants.buttonTextFontSize)
        
        scheduleWishesButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
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
        hideButton.configureCustomButton(target: self, action: #selector(hideButtonValueChanged))
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
    
    @objc
    private func hideButtonValueChanged() {
        isHidden.toggle()
        UIView.animate(withDuration: Constants.animateDuration) {
            self.view.subviews.forEach { $0.alpha = self.isHidden ? 0 : 1 }
        } completion: { _ in
            self.view.subviews.forEach { $0.isHidden = self.isHidden }
        }
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            addWishButton.isHidden = true
        }
    }
    
    @objc
    private func randomizeColor() {
        let color = UIColor.random()
        UIView.animate(withDuration: Constants.animateDuration) { self.view.backgroundColor = color }
    }
    
    @objc
    private func addWishButtonPressed() {
        interactor.loadWishStoring()
    }
}
