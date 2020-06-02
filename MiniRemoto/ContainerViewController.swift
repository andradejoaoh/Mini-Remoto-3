//
//  ContainerViewController.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 22/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit
import os.log

final class ContainerViewController: UIViewController {
    private lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "dotd.container", qos: .userInitiated)
        return queue
    }()

    @AutoLayout var saveBtn: UIButton
    @AutoLayout var loadBtn: UIButton

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
        loadBtn.backgroundColor = .systemBlue
        saveBtn.addTarget(self, action: #selector(test_save), for: .touchUpInside)
        loadBtn.addTarget(self, action: #selector(test_load), for: .touchUpInside)
        view.addSubview(saveBtn)
        view.addSubview(loadBtn)
        NSLayoutConstraint.activate(
            [saveBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
             saveBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
             saveBtn.widthAnchor.constraint(equalToConstant: 50),
             saveBtn.heightAnchor.constraint(equalToConstant: 50)]
        )

        NSLayoutConstraint.activate(
            [loadBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
             loadBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
             loadBtn.widthAnchor.constraint(equalToConstant: 50),
             loadBtn.heightAnchor.constraint(equalToConstant: 50)]
        )
    }

    @objc func test_save() {
        save()
    }

    @objc func test_load() {
        load(canvas: "Canvas")
    }

    private func save() {

        let url = FileManager.userDocumentDirectory

        queue.async { [weak self] in
            if let canvas = self?.canvas.snapshot {
                let fileURL = url.appendingPathComponent(canvas.name).appendingPathExtension("json")
                do {
                    let data = try JSONEncoder().encode(canvas)
                    try data.write(to: fileURL, options: .atomicWrite)
                    os_log("Canvas saved successfully", log: OSLog.persistenceCycle, type: .debug)
                } catch {
                    os_log("Failed to save canvas", log: OSLog.persistenceCycle, type: .error)
                }
            }
        }
    }

    private func load(canvas fileName: String) {

        let url = FileManager.userDocumentDirectory

        let fileURL = url.appendingPathComponent(fileName).appendingPathExtension("json")

        queue.async {
            do {
                let data = try Data(contentsOf: fileURL)
                os_log("Canvas loaded successfully", log: OSLog.persistenceCycle, type: .debug)
            } catch {
                os_log("Failed to load canvas", log: OSLog.persistenceCycle, type: .error)
            }
        }
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
            palette.view.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            palette.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            palette.view.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
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
