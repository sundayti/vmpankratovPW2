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
    var secondColor: UIColor? = nil
    private var gradientLayer = CAGradientLayer()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    // MARK: - Actions
    @objc private func keyPressed(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            keyPressed?(title)
        }
    }
}
