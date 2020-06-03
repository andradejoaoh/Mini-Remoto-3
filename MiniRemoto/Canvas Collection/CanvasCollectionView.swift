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
        contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
