//
//  ImageWidgetViewController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

final class ImageWidgetViewController: UIViewController {

    private let viewModel: ImageWidgetViewModel

    init(viewModel: ImageWidgetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ImageWidgetViewController: WidgetRepresentation {
    func update() {
        //update UI
    }

    func hide() {
        self.view.isHidden = true
    }

    func show() {
        self.view.isHidden = false
    }


}
