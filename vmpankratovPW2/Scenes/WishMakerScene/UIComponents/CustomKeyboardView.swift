//
//  CustomKeyboardView.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 29.10.2024.
//

import UIKit

final class CustomKeyboardView: UIView {
    
    // MARK: - Properties
    var keyPressed: ((String) -> Void)?
    var updateColor: (() -> Void)?
    private var secondColor: UIColor? = nil
    private var inputField: UITextField?
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    private var gradientLayer = CAGradientLayer()
    
    // MARK: - Initialization
    init(frame: CGRect, inputField: UITextField, feedbackGenerator: UIImpactFeedbackGenerator) {
        super.init(frame: frame)
        self.inputField = inputField
        self.feedbackGenerator = feedbackGenerator
        setupGradientBackground()
        setupKeys()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientBackground()
        setupKeys()
    }
    
    // MARK: - Setup Methods
    public func setupGradientBackground(color: UIColor = UIColor.random()) {
        configureGradientLayer(color: color)
        applyGradientToLayer()
    }
    
    private func setupKeys() {
        let buttonTitles = createButtonTitles()
        let gridStackView = createGridStackView()
        
        addSubview(gridStackView)
        layoutButtons(in: gridStackView, with: buttonTitles)
        
        gridStackView.pinHorizontal(to: self, KeyboardConstants.gridStackHorizontal)
        gridStackView.pinTop(to: self.topAnchor, KeyboardConstants.gridStackTop)
    }
    
    // MARK: - Gradient Configuration
    private func configureGradientLayer(color: UIColor) {
        gradientLayer.frame = bounds
        secondColor = secondColor ?? UIColor.random()
        gradientLayer.colors = [
            color.cgColor,
            secondColor!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    private func applyGradientToLayer() {
        if layer.sublayers?.first is CAGradientLayer {
            layer.sublayers?.removeFirst()
        }
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Keyboard Layout
    private func createButtonTitles() -> [String] {
        return KeyboardConstants.symbols + KeyboardConstants.actionButtons
    }
    
    private func createGridStackView() -> UIStackView {
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.spacing = KeyboardConstants.gridStackSpacing
        gridStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        gridStackView.isLayoutMarginsRelativeArrangement = true
        return gridStackView
    }
    
    private func layoutButtons(in gridStackView: UIStackView, with buttonTitles: [String]) {
        var rowStackView = createRowStackView()
        gridStackView.addArrangedSubview(rowStackView)
        
        for (index, title) in buttonTitles.enumerated() {
            let button = createButton(with: title)
            rowStackView.addArrangedSubview(button)
            
            if (index + 1) % KeyboardConstants.rowLength == 0 {
                rowStackView = createRowStackView()
                gridStackView.addArrangedSubview(rowStackView)
            }
        }
    }
    
    private func createRowStackView() -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = KeyboardConstants.rowSpacing
        return rowStackView
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: KeyboardConstants.buttonFontSize)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = KeyboardConstants.buttonRadius
        button.layer.borderWidth = KeyboardConstants.buttonBorderWidth
        button.layer.borderColor = KeyboardConstants.buttonBorderColor.cgColor
        return button
    }
    
    // MARK: - Animation
    func animateGradientChange(to firstColor: UIColor, duration: TimeInterval) {
        let colors = [firstColor, secondColor]
        
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = gradientLayer.colors
        colorAnimation.toValue = colors.map { $0!.cgColor }
        colorAnimation.duration = duration
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        
        gradientLayer.colors = colors.map { $0!.cgColor }
        gradientLayer.add(colorAnimation, forKey: "colorChange")
    }
    
    
    internal func handleCustomKeyboardInput(key: String) {
        checkingTheCorrectnessOfTheFormat()
        feedbackGenerator!.impactOccurred()
        switch key {
        case "Enter":
            inputField?.resignFirstResponder()
        case "Delete":
            deleteLastCharacter()
        case "Delete All":
            inputField?.text = ""
        default:
            appendCharacter(key)
        }
        updateColor!()
    }
    
    private func checkingTheCorrectnessOfTheFormat() {
        guard inputField?.text?.count ?? 0 <= Constants.hexLength else {
            inputField?.text = ""
            return
        }
        for char in inputField?.text ?? "" {
            guard KeyboardConstants.symbols.contains(String(char)) else {
                inputField?.text = ""
                return
            }
        }
    }
    
    
    private func deleteLastCharacter() {
        if inputField?.text?.isEmpty == true { return }
        
        let indices = getCursorPosition()
        let (startIndex, endIndex) = (indices[0], indices[1])
        
        if startIndex < 0 { return }
        if startIndex != endIndex {
            let text = inputField?.text
            let startStringIndex = text?.index(text!.startIndex, offsetBy: startIndex)
            let endStringIndex = text?.index(text!.startIndex, offsetBy: endIndex - 1)
            
            self.inputField?.text?.removeSubrange(startStringIndex!...endStringIndex!)
            
            self.setCursorPosition(in: self.inputField!, position: startIndex)
            return
        }
        if startIndex == 0 { return }
        let text = inputField?.text
        let stringIndex = text?.index(text!.startIndex, offsetBy: (startIndex - 1))
        self.inputField?.text?.remove(at: stringIndex!)
        
        self.setCursorPosition(in: self.inputField!, position: startIndex - 1)
    }
    
    private func appendCharacter(_ key: String) {
        let indices = getCursorPosition()
        let (startIndex, endIndex) = (indices[0], indices[1])
        
        guard startIndex >= 0 else { return }
        
        if startIndex != endIndex {
            removeTextInRange(start: startIndex, end: endIndex)
            setCursorPosition(in: inputField!, position: startIndex)
        }
        
        guard (inputField!.text?.count ?? 0) < Constants.hexLength else { return }
        
        insertCharacter(key, at: startIndex)
        setCursorPosition(in: inputField!, position: startIndex + 1)
        updateColor!()
    }
    
    private func removeTextInRange(start: Int, end: Int) {
        guard let text = inputField!.text else { return }
        let startStringIndex = text.index(text.startIndex, offsetBy: start)
        let endStringIndex = text.index(text.startIndex, offsetBy: end - 1)
        inputField!.text?.removeSubrange(startStringIndex...endStringIndex)
    }
    
    private func insertCharacter(_ character: String, at position: Int) {
        guard let text = inputField!.text else { return }
        let insertIndex = text.index(text.startIndex, offsetBy: position)
        inputField!.text?.insert(contentsOf: character, at: insertIndex)
    }
    
    private func setCursorPosition(in textField: UITextField, position: Int) {
        guard let text = textField.text, position >= 0, position <= text.count else { return }
        let textPosition = textField.position(from: textField.beginningOfDocument, offset: position)
        textField.selectedTextRange = textField.textRange(from: textPosition!, to: textPosition!)
    }
    
    @objc private func getCursorPosition() -> [Int] {
        if let selectedTextRange = inputField!.selectedTextRange {
            let startPosition = selectedTextRange.start
            let endPosition = selectedTextRange.end
            let startIndex = inputField!.offset(from: inputField!.beginningOfDocument, to: startPosition)
            let endIndex = inputField!.offset(from: inputField!.beginningOfDocument, to: endPosition)
            return [startIndex, endIndex]
        }
        return [-1, -1]
    }
    
    // MARK: - Actions
    @objc private func keyPressed(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            keyPressed?(title)
        }
    }
}
