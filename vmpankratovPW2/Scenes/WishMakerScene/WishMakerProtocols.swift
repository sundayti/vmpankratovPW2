//
//  WishMakerProtocols.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 28.10.2024.
//

import UIKit

protocol BusinessLogic {
    func loadStart(_ request: WishMakerModel.BackgroundColor.Request)
}


protocol PresentationLogic {
    func presentStart(_ response: WishMakerModel.BackgroundColor.Response)
    
    func routeTo()
}
