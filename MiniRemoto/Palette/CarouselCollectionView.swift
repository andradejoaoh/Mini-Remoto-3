//
//  CarouselCollectionView.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 19/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

/**
 `UICollectionView` with custom flow layout for single line items with drag enabled

 - Author:
   Rafael Galdino
*/
final class CarouselCollectionView: UICollectionView {
    /**
     `UICollectionView` with custom flow layout for single line items with drag enabled

     - Author:
       Rafael Galdino
    */
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInsetReference = .fromContentInset

        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        self.register(CarouselCellView.self, forCellWithReuseIdentifier: "default")
        self.dragInteractionEnabled = true
        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /**
    Changes minimum period fingers must press on the cell for the gesture to be recognized.

    - Parameters:
       - to:The duration in seconds of the press

    - Author:
    Rafael Galdino
    */

    public func setMinimumPressDuration(to duration: Double = 0.5) {
        self.gestureRecognizers?.forEach { (recognizer) in
            if let longPressRecognizer = recognizer as? UILongPressGestureRecognizer {
                longPressRecognizer.minimumPressDuration = duration
            }
        }
    }
}
