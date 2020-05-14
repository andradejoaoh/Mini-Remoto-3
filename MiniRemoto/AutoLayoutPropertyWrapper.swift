//
//  AutoLayoutPropertyWrapper.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

@propertyWrapper class AutoLayout<T: UIView> {
    private lazy var view: T = {
        let view = T(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var wrappedValue: T {
        return view
    }
}
