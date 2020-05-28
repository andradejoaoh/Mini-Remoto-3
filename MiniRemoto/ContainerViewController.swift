//
//  ContainerViewController.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 22/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

final class ContainerViewController: UIViewController {
    @AutoLayout var saveBtn: UIButton

    private var canvas: CanvasViewController = {
        let canvasController = CanvasViewController(nibName: nil, bundle: nil)
        canvasController.view.translatesAutoresizingMaskIntoConstraints = false
        return canvasController
    }()

    private let palette: PaletteViewController = {
        let paletteController = PaletteViewController()
        paletteController.view.translatesAutoresizingMaskIntoConstraints = false
        return paletteController
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        saveBtn.backgroundColor = .systemRed
        saveBtn.addTarget(self, action: #selector(test_save), for: .touchUpInside)
        view.addSubview(saveBtn)
        NSLayoutConstraint.activate(
            [saveBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
             saveBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
             saveBtn.widthAnchor.constraint(equalToConstant: 50),
             saveBtn.heightAnchor.constraint(equalToConstant: 50)]
        )
    }

    @objc func test_save() {
        print(canvas.snapshot)
    }

    private func setupController() {
        add(controller: canvas)
        positionCanvas()
        add(controller: palette)
        positionPalette()
        mockUpData()
    }

    private func positionCanvas() {
        NSLayoutConstraint.activate([
            canvas.view.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            canvas.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func positionPalette() {
        NSLayoutConstraint.activate([
            palette.view.heightAnchor.constraint(equalToConstant: 125),
            palette.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            palette.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            palette.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func add(controller: UIViewController) {
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }

    private func mockUpData() {
        palette.widgetOptions = [
            TextWidgetModel(),
            ImageWidgetModel()
        ]
    }
}
