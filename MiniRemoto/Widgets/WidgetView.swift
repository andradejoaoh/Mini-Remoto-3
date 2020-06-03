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
    var snapshot: WidgetData { get }
    var state: WidgetState { get set }
    var internalFrame: CGRect { get set }
    func edit()
    func select()
    func deselect()
    func delete()
}

extension WidgetView {
    
    func select() {
        self.view.backgroundColor = UIColor.main
    }
    
    func deselect() {
        self.view.backgroundColor = .white
    }
    
    func delete(){
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}

extension Array where Element == WidgetView {
    
    func contains(view: UIView?) -> WidgetView? {
        var foundWidgetView: WidgetView?
        self.contains(where: { (widgetView) -> Bool in
            if (widgetView.view == view) {
                foundWidgetView = widgetView
                return true
            } else { return false }
        })
        return foundWidgetView
    }
}
