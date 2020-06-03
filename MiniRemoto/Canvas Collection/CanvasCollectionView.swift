//
//  CanvasCollectionView.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 02/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

final class CanvasCollectionView: UICollectionView {
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(CanvasCollectionViewCell.self, forCellWithReuseIdentifier: "canvasCollectionViewCell")
        self.backgroundColor = .dotdBackground
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
