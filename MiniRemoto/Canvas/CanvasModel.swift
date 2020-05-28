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
}
