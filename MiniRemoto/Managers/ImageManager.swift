//
//  ImageManager.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

class ImageManager: UIViewController {
    var selectedImage: UIImage?
    
    func pickImage(){
        
        let actionSheet = UIAlertController(title: "Escolha uma Foto", message: "Selecione o local da foto.", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Galeria", style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                photoPicker.allowsEditing = false
                self?.present(photoPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(photoAction)

        
        let cameraAction = UIAlertAction(title: "Câmera", style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.sourceType = .camera
                
                self?.present(cameraPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension ImageManager: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.selectedImage = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

extension ImageManager: UINavigationControllerDelegate {
}

