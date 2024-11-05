//
//  WishMakerViewController+Keyboard.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 30.10.2024.
//

import UIKit

extension WishMakerViewController {
    internal func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showCustomKeyboard()
    }
    
    private func showCustomKeyboard() {
        customKeyboard = CustomKeyboardView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: KeyboardConstants.height
            ),
            inputField: inputField,
            feedbackGenerator: feedbackGenerator
        )
        
        customKeyboard?.setupGradientBackground(color: view.backgroundColor!)
        inputField.inputView = customKeyboard
        
        customKeyboard?.keyPressed = { [weak self] key in
            self?.customKeyboard!.handleCustomKeyboardInput(key: key)
        }
        customKeyboard?.updateColor = { [weak self] in
            self?.updateBackgroundColorFromHex()
        }
        
    }
    
    private func updateBackgroundColorFromHex() {
        let count = inputField.text?.count ?? 0
        let hex = (inputField.text?.uppercased() ?? "") + String(repeating: "0", count: Constants.hexLength - count)
        let color = UIColor(hex: "#\(hex)")
        
        UIView.animate(withDuration: Constants.animateDuration) {
            self.customKeyboard?.animateGradientChange(to: color ?? .white, duration: Constants.animateDuration)
            self.view.backgroundColor = color ?? .white
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -keyboardFrame.height
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}
