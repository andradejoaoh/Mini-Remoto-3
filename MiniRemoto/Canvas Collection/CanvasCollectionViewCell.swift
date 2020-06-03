//
//  CanvasCollectionViewCell.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 15/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//
import UIKit

class CanvasCollectionViewCell: UICollectionViewCell {
    @AutoLayout var nameLabel: UILabel
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = .systemRed

        let selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView.backgroundColor = UIColor.dotdMain

        self.backgroundView = backgroundView
        self.selectedBackgroundView = selectedBackgroundView
        configureLabel()
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

    func configureLabel() {
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)
        ])
        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 24.0)
        nameLabel.textColor = UIColor.dotdGrey
    }
}
