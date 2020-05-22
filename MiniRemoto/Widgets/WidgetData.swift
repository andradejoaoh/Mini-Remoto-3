//
//  WidgetData.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 22/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

enum WidgetType: String {
    case text = "text"
    case image = "image"
    case placeholder = "placeholder"
}

protocol WidgetData {
    var type: WidgetType { get }
    var frame: CGRect { get set }
    func make() -> WidgetView
}

struct TextWidgetModel: WidgetData {
    var type: WidgetType
    var frame: CGRect
    var title: String
    var body: String

    init(frame: CGRect = CGRect.zero, title: String = "", body: String = "") {
        self.type = WidgetType.text
        self.frame = frame
        self.title = title
        self.body = body
    }
}

struct ImageWidgetModel: WidgetData {
    var type: WidgetType
    var frame: CGRect
    var image: UIImage

    init(frame: CGRect = CGRect.zero, image: UIImage = UIImage()) {
        self.type = WidgetType.text
        self.frame = frame
        self.image = image
    }
}

