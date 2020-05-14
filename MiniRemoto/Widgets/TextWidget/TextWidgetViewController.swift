//
//  TextWidgetViewController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

final class TextWidgetViewController: UIViewController {
    
}

extension TextWidgetViewController: WidgetRepresentation {
    func hide() {
        self.view.isHidden = true
    }

    func show() {
        self.view.isHidden = false
    }

    func update() {
        //update UI
    }

}
