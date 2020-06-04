//
//  ImageWidgetController.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 01/06/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import os.log

final class ImageWidgetController {

    var imageData: Data? {
        didSet {
            save()
        }
    }

    var imageID: String?

    func load(image id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = FileManager.userDocumentDirectory.appendingPathComponent("media")

        let fileURL = url.appendingPathComponent(id).appendingPathExtension("png")

        do {
            let data = try Data(contentsOf: fileURL)
            completion(.success(data))
            os_log("Loaded image successfully", log: OSLog.imageLoadingCycle, type: .debug)
        } catch {
            completion(.failure(error))
            os_log("Failed to load image", log: OSLog.imageLoadingCycle, type: .error)
        }
    }


    private func save() {
        let url = FileManager.userDocumentDirectory.appendingPathComponent("media")

        guard let imageID = imageID else { return }
        print(imageID)
        let fileURL = url.appendingPathComponent(imageID).appendingPathExtension("png")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                try self.imageData?.write(to: fileURL, options: .atomicWrite)
                os_log("Saved image successfully", log: OSLog.imageLoadingCycle, type: .debug)
            } catch {
                os_log("Failed to save image", log: OSLog.imageLoadingCycle, type: .error)
            }
        }
    }

}
