//
//  MainViewController.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 15/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

class CanvasCollectionViewController: UIViewController {
    
    @AutoLayout public var collectionView: CanvasCollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
            carouselGuide.bottomAnchor.constraint(equalTo:viewGuide.bottomAnchor),
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
    }

    @objc
    func doneEditing() {
        print(collectionView.indexPathsForSelectedItems ?? [])
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        defaultMode()
    }

    private func createCanvas(named name: String) {
        print("\(name) created with success!")
        //TODO: Create new Canvas
        #warning("Canvas creation mocked. Actual implementation pending")
    }

    private func deleteCanvas() {
        //TODO: Delete new Canvas
        #warning("Canvas deletion mocked. Actual implementation pending")
    }

    private func newCanvasAlert() -> UIAlertController {
        let alertVC = UIAlertController(title: "New Canvas", message: "Please type the name of the canvas", preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "i.e. MyCanvas"
        }

        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] (alertAction) in
            if let answer = alertVC.textFields?.first {
                self?.createCanvas(named: answer.text ?? "nil value")
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
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)

        return alertVC
    }

    private func showCanvas() {
        if let splitView = self.splitViewController as? RootSplitViewController, let detail = splitView.detail {
            splitView.showDetailViewController(detail, sender: nil)
        }
    }
}

extension CanvasCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        } else {
            showCanvas()
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "canvasCollectionViewCell", for: indexPath) as! CanvasCollectionViewCell
        
        cell.contentView.backgroundColor = UIColor.systemTeal
        
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
