//
//  WishMakerInteractor.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 04.11.2024.
//

import UIKit

final class WishMakerInteractor: BusinessLogic {
    private let presenter: PresentationLogic
    
    init(presenter: PresentationLogic) {
        self.presenter = presenter
    }
    
    func loadStart(_ request: WishMakerModel.BackgroundColor.Request) {
        let red = request.red
        let green = request.green
        let blue = request.blue
        
        let color = UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: 1
        )
        
        presenter.presentStart(WishMakerModel.BackgroundColor.Response(color: color))
    }
}
