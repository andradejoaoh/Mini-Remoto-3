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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CanvasCollectionViewCell.self, forCellWithReuseIdentifier: "canvasCollectionViewCell")
        collectionView.backgroundColor = .clear

        self.view.addSubview(collectionView)
    }
}

extension CanvasCollectionViewController: UICollectionViewDelegate {

}

extension CanvasCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "canvasCollectionViewCell", for: indexPath) as! CanvasCollectionViewCell
        
        cell.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 4
        
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
