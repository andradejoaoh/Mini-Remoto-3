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
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "dotPattern") ?? UIImage())

        let selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView.backgroundColor = UIColor.dotdMain

        self.backgroundView = backgroundView
        self.selectedBackgroundView = selectedBackgroundView

        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.dotdMain.cgColor
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
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 24.0)
        nameLabel.textColor = UIColor.dotdGrey
        nameLabel.textAlignment = .center
    }
}
