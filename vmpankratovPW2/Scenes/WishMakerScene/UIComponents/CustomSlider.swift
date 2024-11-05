//
//  CustomSlider.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 28.10.2024.
//

import UIKit

final class CustomSlider: UIView {
    
    // MARK: - Properties
    var valueChanged: ((Double) -> Void)?
    
    var slider = UISlider()
    var titleView = UILabel()
    
    // MARK: - Initialization
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        titleView.font = .systemFont(ofSize: SliderConstants.fontSize)
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(slider)
        addSubview(titleView)

        titleView.pinHorizontal(to: self, SliderConstants.titleViewHorizontal)
        titleView.pinTop(to: self, SliderConstants.titleViewTop)
        
        slider.pinTop(to: titleView.bottomAnchor)
        slider.pinHorizontal(to: self, SliderConstants.sliderHorizontal)
        slider.pinBottom(to: self, SliderConstants.sliderBottom)
    }
    
    // MARK: - Actions
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
