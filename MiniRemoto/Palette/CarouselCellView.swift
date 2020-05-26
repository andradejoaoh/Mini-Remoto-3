//
//  CarouselCellView.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 19/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

/**
 `UICollectionViewCell` with an `UIImageView` scaled to aspect fit.

 `CarouselCollectionView` standard cell
 
 - Author:
   Rafael Galdino
*/
final class CarouselCellView: UICollectionViewCell {
    @AutoLayout public var imageView: UIImageView
    public var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }
    
    /**
     `UICollectionViewCell` with an `UIImageView` scaled to aspect fit.

     `CarouselCollectionView` standard cell

     - Author:
       Rafael Galdino
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
