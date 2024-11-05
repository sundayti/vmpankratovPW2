//
//  WishMakerPresenter.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 04.11.2024.
//

import UIKit

final class WishMakerPresenter: PresentationLogic {
    internal weak var view: WishMakerViewController?
    
    func presentStart(_ response: WishMakerModel.BackgroundColor.Response) {
        let color = response.color
        view?.updateBackgroundColor(color)
    }
    
    func routeTo() {
        view?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
