//
//  WishMakerViewController+UI.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 29.10.2024.
//

import UIKit

extension WishMakerViewController {
    func createStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layer.cornerRadius = Constants.radius
        stack.clipsToBounds = true
        stack.backgroundColor = .white
        view.addSubview(stack)
        return stack
    }
    
    func createSliders() -> [CustomSlider] {
        return [
            CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax),
            CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax),
            CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        ]
    }
    
    func setupInitialSliderValues(_ sliders: [CustomSlider]) {
        guard let backgroundColor = view.backgroundColor else { return }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        backgroundColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        sliders[0].slider.value = Float(red)
        sliders[1].slider.value = Float(green)
        sliders[2].slider.value = Float(blue)
    }
    
    func setupSliderActions(_ sliders: [CustomSlider]) {
        sliders[0].valueChanged = { [weak self] red in
            self!.interactor.loadStart(WishMakerModel.BackgroundColor.Request(red: Float(red),
                                                                              green: sliders[1].slider.value,
                                                                              blue: sliders[2].slider.value))
        }
        sliders[1].valueChanged = { [weak self] green in
            self!.interactor.loadStart(WishMakerModel.BackgroundColor.Request(red: sliders[0].slider.value,
                                                                              green: Float(green),
                                                                              blue: sliders[2].slider.value))
        }
        sliders[2].valueChanged = { [weak self] blue in
            self!.interactor.loadStart(WishMakerModel.BackgroundColor.Request(red: sliders[0].slider.value,
                                                                              green: sliders[1].slider.value,
                                                                              blue: Float(blue)))
        }
    }
    
    func updateBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
