//
//  WishMakerProtocols.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 28.10.2024.
//

import UIKit

protocol BusinessLogic {
    func loadBackground(_ request: WishMakerModel.BackgroundColor.Request)
    
    func loadWishStoring()
}


protocol PresentationLogic {
    func presenBackground(_ response: WishMakerModel.BackgroundColor.Response)
    
    func routeToWishStoring()
}
