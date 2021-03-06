//
//  ImageWidgetView.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

/// A representation of an `ImageWidget`. This `WidgetView`
/// should only be instantiated when being added to a Canvas.
final class ImageWidgetView: UIViewController, WidgetView {
    var snapshot: WidgetData {
        controller.imageData = image?.pngData()
        return ImageWidgetModel(frame: Frame(rect: internalFrame), id: imageID)
    }

    var internalFrame: CGRect = CGRect.zero

    /// The state of a `WidgetState`.
    var state: WidgetState {
        didSet {
            switch self.state {
            case .idle:
                break
            case .editing:
                edit()
            }
        }
    }

    /// The UIImageView used to display a `ImageWidget`'s image.
    /// This UIImageView will fill the entirety of a `ImageWidget`'s frame.
    @AutoLayout private var imageView: UIImageView

    /// The image being displayed. It is assumed that
    /// the Canvas will provide an UIImage ready to be used.
    private var image: UIImage? {
        didSet {
            self.updateImage(self.image ?? UIImage())
        }
    }
    private var imageID: String

    private let controller: ImageWidgetController

    /// Initialise a new instace of this type:
    /// - parameter image: the image to be displayed.
    init(id: String) {
        self.state = .idle
        self.controller = ImageWidgetController()
        self.imageID = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.state = .idle
        self.image = UIImage()
        self.controller = ImageWidgetController()
        self.imageID = ""
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        controller.load(image: imageID) { [weak self] (image) in
            guard let self = self else { return }
            switch image {
            case .success(let data):
                self.image = UIImage(data: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setInteractions(canvas: CanvasViewController) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: canvas, action: #selector(canvas.tappedWidget(_:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: canvas, action: #selector(canvas.draggedWidget(_:))))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: canvas, action: #selector(canvas.longPressedWidget(_:))))
    }

    /// Set the UI up with constraints to match a `ImageWidget`'s frame.
    private func setupUI() {
        view.backgroundColor = .dotdGrey
        view.layer.cornerRadius = view.frame.height * 0.005
        view.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.image = image

        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /// Updates an `ImageWidget`'s image with the `UIImage` passed as the parameter.
    /// It also registers a new undo operation in the `UndoManager`. Updating of a
    /// `ImageWidget`'s image should be done through this function to maintain the correct
    /// order of operations in the `UndoManager`.
    /// - parameter image: The new image to be set.
    private func updateImage(_ image: UIImage) {
        guard let currentImage = self.image else { return }
        controller.imageID = imageID
        self.imageView.image = image

        undoManager?.registerUndo(withTarget: self, handler: { (target) in
            target.updateImage(currentImage)
        })
    }

    func edit() {
        let actionSheet = UIAlertController(title: "Choose a Picture", message: "Select the photo's source", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Gallery", style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                photoPicker.allowsEditing = false
                self?.present(photoPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(photoAction)


        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.sourceType = .camera

                self?.present(cameraPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(cameraAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension ImageWidgetView: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

extension ImageWidgetView: UINavigationControllerDelegate {
}
