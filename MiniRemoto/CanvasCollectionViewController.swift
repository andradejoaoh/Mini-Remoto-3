//
//  MainViewController.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 15/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

class CanvasCollectionViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CanvasCollectionViewCell.self, forCellWithReuseIdentifier: "canvasCollectionViewCell")
        collectionView.backgroundColor = .clear
        addBarButtons()

        self.view.addSubview(collectionView)

        positionCollectionView()
    }

    private func positionCollectionView() {
        let carouselGuide = collectionView.safeAreaLayoutGuide
        let viewGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            carouselGuide.topAnchor.constraint(equalTo:viewGuide.topAnchor),
            carouselGuide.bottomAnchor.constraint(equalTo:viewGuide.bottomAnchor),
            carouselGuide.trailingAnchor.constraint(equalTo:viewGuide.trailingAnchor),
            carouselGuide.leadingAnchor.constraint(equalTo:viewGuide.leadingAnchor)
        ])
    }

    private func addBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }

    @objc
    func addTapped() {
        present(newCanvasAlert(), animated: true, completion: nil)
    }

    @objc
    func editTapped() {
        print("edit mode on")
        print("edit mode off")
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

    private func createCanvas(named name: String) {
        print("\(name) created with success!")
    }
}

extension CanvasCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let splitView = self.splitViewController as? RootSplitViewController {
            let detail = splitView.detail
            splitView.showDetailViewController(detail, sender: nil)
        }
    }
}

extension CanvasCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "canvasCollectionViewCell", for: indexPath) as! CanvasCollectionViewCell
        
        cell.contentView.backgroundColor = UIColor.systemRed
        
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
