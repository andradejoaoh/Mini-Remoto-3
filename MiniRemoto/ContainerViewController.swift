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

struct ContainerModel: Codable {
    var canvas: CanvasModel
}

final class ContainerViewController: UIViewController {
    var snapshot: ContainerModel {
        return ContainerModel(canvas: canvas.snapshot)
    }
    private lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "dotd.container", qos: .userInitiated)
        return queue
    }()

    private var model: ContainerModel {
        didSet {
            canvas.restore(model.canvas)
        }
    }

    func update(_ model: ContainerModel) {
        self.model = model
    }


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

    init(model: ContainerModel = ContainerModel(canvas: CanvasModel(name: "", lastModifiedAt: "", createdAt: ""))) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.model = ContainerModel(canvas: CanvasModel(name: "", lastModifiedAt: "", createdAt: ""))
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }

    private func save() {

        let url = FileManager.userDocumentDirectory

        queue.async { [weak self] in
            if let container = self?.snapshot {
                let fileURL = url.appendingPathComponent(container.canvas.name).appendingPathExtension("json")
                do {
                    let data = try JSONEncoder().encode(container)
                    try data.write(to: fileURL, options: .atomicWrite)
                    os_log("Canvas saved successfully", log: OSLog.persistenceCycle, type: .debug)
                } catch {
                    os_log("Failed to save canvas", log: OSLog.persistenceCycle, type: .error)
                }
            }
        }
    }

    func load(canvas fileName: String) {

        let url = FileManager.userDocumentDirectory

        let fileURL = url.appendingPathComponent(fileName).appendingPathExtension("json")

        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: fileURL)
                self.model = try JSONDecoder().decode(ContainerModel.self, from: data)
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
