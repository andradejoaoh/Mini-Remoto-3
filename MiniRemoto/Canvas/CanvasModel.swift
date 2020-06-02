//
//  CanvasModel.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 28/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation

struct CanvasModel: Codable {
    let name: String
    let lastModifiedAt: String
    let createdAt: String
    let textWidgets: [TextWidgetModel]
    let imageWidgets: [ImageWidgetModel]

    init(name: String,
         lastModifiedAt: String,
         createdAt: String,
         textWidgets: [TextWidgetModel] = [],
         imageWidgets: [ImageWidgetModel] = []) {
        self.name = name
        self.lastModifiedAt = lastModifiedAt
        self.createdAt = createdAt
        self.textWidgets = textWidgets
        self.imageWidgets = imageWidgets
    }
}
