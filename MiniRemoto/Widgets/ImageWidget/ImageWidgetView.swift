//
//  ImageWidgetView.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

/// A representation of an Image Widget. This WidgetView
/// should only be instantiated when being added to a Canvas.
final class ImageWidgetView: WidgetView {
    /// The UIImageView used to display this ImageWidget's image.
    /// This UIImageView will fill the entirety of this ImageWidget's frame.
    @AutoLayout private var imageView: UIImageView

    /// The image being displayed. It is assumed that
    /// the Canvas will provide an UIImage ready to be used.
    private var image: UIImage

    /// Initialise a new instace of this type:
    /// - parameter image: the image to be displayed.
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// Set the UI up with constraints to match this ImageWidget's frame.
    private func setupUI() {
        view.backgroundColor = .systemBackground

        imageView.contentMode = .scaleAspectFit
        imageView.image = image

        view.addSubview(imageView)

        NSLayoutConstraint.activate(
            [imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
             imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
             imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        )
    }
}
