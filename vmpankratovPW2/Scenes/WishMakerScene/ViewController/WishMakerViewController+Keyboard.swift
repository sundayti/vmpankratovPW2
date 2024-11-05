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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -keyboardFrame.height
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showCustomKeyboard()
    }
    
    private func showCustomKeyboard() {
        customKeyboard = CustomKeyboardView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: KeyboardConstants.height))
        customKeyboard?.setupGradientBackground(color: view.backgroundColor!)
        inputField.inputView = customKeyboard
        
        customKeyboard?.keyPressed = { [weak self] key in
            self?.handleCustomKeyboardInput(key: key)
        }
    }
    
    internal func handleCustomKeyboardInput(key: String) {
        checkingTheCorrectnessOfTheFormat()
        feedbackGenerator.impactOccurred()
        switch key {
        case "Enter":
            inputField.resignFirstResponder()
        case "Delete":
            deleteLastCharacter()
        case "Delete All":
            inputField.text = ""
        default:
            appendCharacter(key)
        }
        updateBackgroundColorFromHex()
    }
    
    private func checkingTheCorrectnessOfTheFormat() {
        guard inputField.text?.count ?? 0 <= Constants.hexLength else {
            inputField.text = ""
            return
        }
        for char in inputField.text ?? "" {
            guard KeyboardConstants.symbols.contains(String(char)) else {
                inputField.text = ""
                return
            }
        }
    }
    
    
    private func deleteLastCharacter() {
        if inputField.text?.isEmpty == true { return }
        
        let indices = getCursorPosition()
        let (startIndex, endIndex) = (indices[0], indices[1])
        
        if startIndex < 0 { return }
        if startIndex != endIndex {
            let text = inputField.text
            let startStringIndex = text?.index(text!.startIndex, offsetBy: startIndex)
            let endStringIndex = text?.index(text!.startIndex, offsetBy: endIndex - 1)
            
            self.inputField.text?.removeSubrange(startStringIndex!...endStringIndex!)
            
            self.setCursorPosition(in: self.inputField, position: startIndex)
            return
        }
        if startIndex == 0 { return }
        let text = inputField.text
        let stringIndex = text?.index(text!.startIndex, offsetBy: (startIndex - 1))
        self.inputField.text?.remove(at: stringIndex!)
        
        self.setCursorPosition(in: self.inputField, position: startIndex - 1)
    }
    
    private func appendCharacter(_ key: String) {
        let indices = getCursorPosition()
        let (startIndex, endIndex) = (indices[0], indices[1])
        
        guard startIndex >= 0 else { return }
        
        if startIndex != endIndex {
            removeTextInRange(start: startIndex, end: endIndex)
            setCursorPosition(in: inputField, position: startIndex)
        }
        
        guard (inputField.text?.count ?? 0) < Constants.hexLength else { return }
        
        insertCharacter(key, at: startIndex)
        setCursorPosition(in: inputField, position: startIndex + 1)
        updateBackgroundColorFromHex()
    }
    
    private func removeTextInRange(start: Int, end: Int) {
        guard let text = inputField.text else { return }
        let startStringIndex = text.index(text.startIndex, offsetBy: start)
        let endStringIndex = text.index(text.startIndex, offsetBy: end - 1)
        inputField.text?.removeSubrange(startStringIndex...endStringIndex)
    }
    
    private func insertCharacter(_ character: String, at position: Int) {
        guard let text = inputField.text else { return }
        let insertIndex = text.index(text.startIndex, offsetBy: position)
        inputField.text?.insert(contentsOf: character, at: insertIndex)
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
    
    private func setCursorPosition(in textField: UITextField, position: Int) {
        guard let text = textField.text, position >= 0, position <= text.count else { return }
        let textPosition = textField.position(from: textField.beginningOfDocument, offset: position)
        textField.selectedTextRange = textField.textRange(from: textPosition!, to: textPosition!)
    }
    
    @objc private func getCursorPosition() -> [Int] {
        if let selectedTextRange = inputField.selectedTextRange {
            let startPosition = selectedTextRange.start
            let endPosition = selectedTextRange.end
            let startIndex = inputField.offset(from: inputField.beginningOfDocument, to: startPosition)
            let endIndex = inputField.offset(from: inputField.beginningOfDocument, to: endPosition)
            return [startIndex, endIndex]
        }
        return [-1, -1]
    }
}
