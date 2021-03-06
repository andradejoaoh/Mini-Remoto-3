//
//  MainViewController.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 15/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit
import os.log

class CanvasCollectionViewController: UIViewController {
    
    @AutoLayout public var collectionView: CanvasCollectionView

    private var containers: [ContainerModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        }
    }

    lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "dotd.container", qos: .userInitiated)
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.navigationController?.navigationBar.tintColor = .dotdMain
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        containers.removeAll(keepingCapacity: false)
        loadCanvases()
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        defaultMode()
        placeCollectionView()
    }

    private func placeCollectionView() {
        self.view.addSubview(collectionView)
        let carouselGuide = collectionView.safeAreaLayoutGuide
        let viewGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            carouselGuide.topAnchor.constraint(equalTo:viewGuide.topAnchor),
            carouselGuide.bottomAnchor.constraint(equalTo:view.bottomAnchor),
            carouselGuide.trailingAnchor.constraint(equalTo:viewGuide.trailingAnchor),
            carouselGuide.leadingAnchor.constraint(equalTo:viewGuide.leadingAnchor)
        ])
    }

    public func defaultMode() {
        setBarToDefault()
        collectionView.allowsMultipleSelection = false
    }

    public func editMode() {
        setBarToEdit()
        collectionView.allowsMultipleSelection = true
    }

    private func setBarToDefault() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCanvas))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editCollection))
    }

    private func setBarToEdit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCanvases))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
    }

    @objc
    func addCanvas() {
        present(newCanvasAlert(), animated: true, completion: nil)
    }

    @objc
    func editCollection() {
        editMode()
    }

    @objc
    func deleteCanvases() {
        present(deleteCanvasAlert(), animated: true, completion: nil)
        defaultMode()
    }

    @objc
    func doneEditing() {
        defaultMode()
    }

    private func createCanvas(named name: String) {
        if let splitView = self.splitViewController as? RootSplitViewController, let detail = splitView.detail {
            let canvasModel = CanvasModel(name: name, lastModifiedAt: "", createdAt: "")
            let containerModel = ContainerModel(canvas: canvasModel)
            detail.update(containerModel)
            splitView.showDetailViewController(detail, sender: nil)
        }
    }

    private func deleteCanvas() {
        for index in collectionView.indexPathsForSelectedItems ?? [] {
            let canvasName = containers[index.item].canvas.name
            deleteCanvasFile(named: canvasName)
            containers.remove(at: index.item)
        }
    }

    private func newCanvasAlert() -> UIAlertController {
        let alertVC = UIAlertController(title: "New Canvas", message: "Please type the name of the canvas", preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "i.e. MyCanvas"
        }

        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] (alertAction) in
            if let answer = alertVC.textFields?.first {
                self?.createCanvas(named: answer.text ?? "MyCanvas")
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addAction(createAction)
        alertVC.addAction(cancelAction)
        
        return alertVC
    }

    private func deleteCanvasAlert() -> UIAlertController {
        let alertVC = UIAlertController(title: "Delete Canvas", message: "This action is irreversible. Are you sure you want to delete the canvas?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (alertAction) in
            self?.deleteCanvas()
            self?.defaultMode()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)

        return alertVC
    }

    private func showCanvas(index: Int) {
        if let splitView = self.splitViewController as? RootSplitViewController, let detail = splitView.detail {
            detail.update(containers[index])
            splitView.showDetailViewController(detail, sender: nil)
        }
    }

    func loadCanvases() {
        let url = FileManager.userDocumentDirectory.appendingPathComponent("canvases")
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let canvases = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                for canvas in canvases {
                    let canvasData = try Data(contentsOf: canvas)
                    let canvasJSON = try JSONDecoder().decode(ContainerModel.self, from: canvasData)
                    self.containers.append(canvasJSON)
                }
                os_log("Canvas loaded successfully", log: OSLog.persistenceCycle, type: .debug)
            } catch {
                os_log("Failed to load canvas", log: OSLog.persistenceCycle, type: .error)
            }
        }
    }

    func deleteCanvasFile(named: String) {
        let canvasURL = FileManager.userDocumentDirectory.appendingPathComponent("canvases").appendingPathComponent(named).appendingPathExtension("json")
        do {
            try FileManager.default.removeItem(at: canvasURL)
            os_log("Canvas deleted successfully", log: OSLog.persistenceCycle, type: .debug)
        } catch {
            os_log("Failed to delete canvas", log: OSLog.persistenceCycle, type: .error)
        }
    }

}

extension CanvasCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        } else {
            showCanvas(index: indexPath.item)
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension CanvasCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "canvasCollectionViewCell", for: indexPath) as! CanvasCollectionViewCell

//        TODO: Place Screenshot
        cell.contentView.backgroundColor = .clear
        cell.nameLabel.text = containers[indexPath.item].canvas.name
        
        return cell
    }
}

extension CanvasCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2 - 30, height: self.collectionView.frame.width/2 - 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
