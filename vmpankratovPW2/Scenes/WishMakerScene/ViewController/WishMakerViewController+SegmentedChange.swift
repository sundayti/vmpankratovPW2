//
//  WishMakerViewController+SegmentedChange.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 30.10.2024.
//

import UIKit

extension WishMakerViewController {
    internal func handleSegmentChange(index: Int) {
        if index >= colorChangesStack.arrangedSubviews.count { return }
        var oldIndex: Int = 0
        for ind in colorChangesStack.arrangedSubviews.indices {
            if colorChangesStack.arrangedSubviews[ind].isHidden == false {
                oldIndex = ind
            }
        }
        
        self.setupInitialSliderValues(self.sliders)
        self.updateHEXInputWithCurrentColor()
        self.inputField.resignFirstResponder()
        
        UIView.animate(withDuration: Constants.animateDuration, animations: {
            self.colorChangesStack.arrangedSubviews.forEach { $0.alpha = 0 } // Скрытие
            self.colorChangesStack.arrangedSubviews[oldIndex].isHidden = true
        }) { _ in
            self.colorChangesStack.layoutIfNeeded()
            
            UIView.animate(withDuration: Constants.animateDuration, animations: {
                self.showSubview(at: index) // Показываем текущий элемент
                self.colorChangesStack.arrangedSubviews.forEach { $0.alpha = 1 } // Плавно показываем
            })
        }
    }
}
