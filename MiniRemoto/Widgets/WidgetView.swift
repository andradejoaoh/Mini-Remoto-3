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
    func edit()
    func delete()
    func save(completion: @escaping (WidgetData) -> Void)
}

extension WidgetView {
    func delete(){
        self.removeFromParent()
    }

    func save(completion: @escaping (WidgetData) -> Void) {
        completion(self.snapshot)
    }
}
