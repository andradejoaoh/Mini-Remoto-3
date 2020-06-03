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
    private var queue: DispatchQueue

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

    init(model: ContainerModel = ContainerModel(canvas: CanvasModel(name: "", lastModifiedAt: "", createdAt: "")), queue: DispatchQueue) {
        self.model = model
        self.queue = queue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.model = ContainerModel(canvas: CanvasModel(name: "", lastModifiedAt: "", createdAt: ""))
        self.queue = DispatchQueue(label: "nil")
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        self.navigationController?.navigationBar.tintColor = .dotdMain
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }

    private func save() {
        let canvasesURL = FileManager.userDocumentDirectory.appendingPathComponent("canvases")
        queue.async { [weak self] in
            if let container = self?.snapshot {
                let name: String = container.canvas.name
                let fileURL = canvasesURL.appendingPathComponent(name).appendingPathExtension("json")
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


//    private func canvasName(name: String) -> String {
//        var canvasName = name
//        let formatter = DateFormatter()
//        //2016-12-08 03:37:22 +0000
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let now = Date()
//        let dateString = formatter.string(from:now)
//        canvasName += dateString
//        return canvasName
//    }
    
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
            TitleTextWidgetModel(),
            BodyTextWidgetModel(),
            ImageWidgetModel()
        ]
    }
}
