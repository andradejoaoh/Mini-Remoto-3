//
//  ImageWidgetController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 01/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation


final class ImageWidgetController {

    var imageData: Data? {
        didSet {
            save()
        }
    }

    var imageID: String?

    func load(image id: String) -> Data {
        let url = FileManager.userDocumentDirectory

        let fileURL = url.appendingPathComponent(id).appendingPathExtension("png")

        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print(error)
        }
        return Data()
    }


    private func save() {
        let url = FileManager.userDocumentDirectory

        guard let imageID = imageID else { return }
        let fileURL = url.appendingPathComponent(imageID).appendingPathExtension("png")
        do {
            try imageData?.write(to: fileURL, options: .atomicWrite)
        } catch {
            print(error)
        }
    }

}
