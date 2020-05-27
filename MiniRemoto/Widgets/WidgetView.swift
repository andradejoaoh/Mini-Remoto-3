//
//  WidgetView.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

enum WidgetState {
    case idle
    case editing
}

extension WidgetState {
    mutating func toggle() {
        switch self {
        case .idle:
            self = .editing
        case .editing:
            self = .idle
        }
    }
}


protocol WidgetView: UIViewController {
    var state: WidgetState { get set }
    func edit()
    func select()
    func deselect()
    func delete()
}

extension WidgetView {
    
    func select() {
        self.view.backgroundColor = .systemPink
    }
    
    func deselect() {
        self.view.backgroundColor = .white
    }
    
    func delete(){
        self.removeFromParent()
    }
}
