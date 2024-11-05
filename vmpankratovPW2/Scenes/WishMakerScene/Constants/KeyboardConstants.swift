//
//  KeyboardConstants.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 05.11.2024.
//

import UIKit

enum KeyboardConstants {
    static let height: CGFloat = 270
    
    static let symbols: [String] = (0...9).map { "\($0)" } + ["A", "B", "C", "D", "E", "F"]
    static let actionButtons: [String] = ["Enter", "Delete All", "Delete"]
    
    static let gridStackHorizontal: CGFloat = 10
    static let gridStackTop: CGFloat = 10
    static let gridStackSpacing: CGFloat = 5
    static let rowLength: Int = 4
    
    static let rowSpacing: CGFloat = 5
    
    static let buttonFontSize: CGFloat = 20
    static let buttonRadius: CGFloat = 10
    static let buttonBorderWidth: CGFloat = 1
    static let buttonBorderColor: UIColor = .black
}
