//
//  CustomInput.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 29.10.2024.
//

import UIKit

final class CustomInputField: UIView {
    
    // MARK: - Properties
    var inputField: UITextField!
    var titleView = UILabel()
    
    // MARK: - Initialization
    init(title: String, inputField: UITextField) {
        super.init(frame: .zero)
        titleView.text = title
        self.inputField = inputField
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        backgroundColor = .white
        titleView.font = .boldSystemFont(ofSize: InputFieldConstants.fontSize)
        
        addSubview(inputField)
        addSubview(titleView)
        
        titleView.pinLeft(to: leadingAnchor, InputFieldConstants.titleViewLeft)
        titleView.pinCenterY(to: self)
        
        inputField.pinCenterY(to: self)
        inputField.pinRight(to: trailingAnchor, InputFieldConstants.inputFieldRight)
        inputField.pinLeft(to: titleView.trailingAnchor, InputFieldConstants.inputFieldLeft)
    }
}
