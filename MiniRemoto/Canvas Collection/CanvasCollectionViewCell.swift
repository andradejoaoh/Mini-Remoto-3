//
//  CanvasCollectionViewCell.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 15/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//
import UIKit

class CanvasCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = .systemRed

        let selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView.backgroundColor = .systemGreen

        self.backgroundView = backgroundView
        self.selectedBackgroundView = selectedBackgroundView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            self.contentView.alpha = isSelected ? 0.5 : 1
        }
    }

    override var isHighlighted: Bool {
        didSet {
            self.contentView.alpha = isHighlighted ? 0.7 : 1
        }
    }
}
