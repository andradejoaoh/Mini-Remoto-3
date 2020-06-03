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
    let titleTextWidgets: [TitleTextWidgetModel]
    let bodyTextWidgets: [BodyTextWidgetModel]
    let imageWidgets: [ImageWidgetModel]

    init(name: String,
         lastModifiedAt: String,
         createdAt: String,
         titleTextWidgets: [TitleTextWidgetModel] = [],
         bodyTextWidgets: [BodyTextWidgetModel] = [],
         imageWidgets: [ImageWidgetModel] = []) {
        self.name = name
        self.lastModifiedAt = lastModifiedAt
        self.createdAt = createdAt
        self.titleTextWidgets = titleTextWidgets
        self.bodyTextWidgets = bodyTextWidgets
        self.imageWidgets = imageWidgets
    }
}
