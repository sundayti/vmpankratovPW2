//
//  WishMakerAssembly.swift
//  vmpankratovPW2
//
//  Created by Tom Tim on 04.11.2024.
//

import UIKit
class Assembly {
    static func build() -> UIViewController {
        let presenter = WishMakerPresenter()
        let interactor = WishMakerInteractor(presenter: presenter)
        let view = WishMakerViewController(interactor: interactor)
        presenter.view = view
        return view
    }
}
