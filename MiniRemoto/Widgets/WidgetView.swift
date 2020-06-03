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
    func setInteractions(canvas: CanvasViewController)
}

extension WidgetView {
    
    func select() {
        self.view.backgroundColor = .dotdMain
    }
    
    func deselect() {
        self.view.backgroundColor = .dotdGrey
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
            if let bodyText = widgetView as? BodyTextWidgetView {
                if bodyText.gesturesView === view {
                    foundWidgetView = bodyText
                    return true
                } else { return false }
            }
            else if (widgetView.view === view) {
                foundWidgetView = widgetView
                return true
            } else { return false }
        })
        return foundWidgetView
    }
}
