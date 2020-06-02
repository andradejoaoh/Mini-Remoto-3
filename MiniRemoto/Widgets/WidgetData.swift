//
//  WidgetData.swift
//  MiniRemoto
//
//  Created by Rafael Galdino on 22/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit

protocol WidgetData: Codable {
    var frame: Frame { get }
    var iconPath: String { get }
    func make() -> WidgetView
}

extension WidgetData {
    var iconImage: UIImage {
        return UIImage(systemName: self.iconPath) ?? UIImage()
    }
}

struct Frame: Codable {
    let x: Float
    let y: Float
    let width: Float
    let height: Float
}

extension Frame {
    static let zero: Frame = {
        return Frame(x: 0, y: 0, width: 0, height: 0)
    }()

    init(rect: CGRect) {
        self.x = Float(rect.origin.x)
        self.y = Float(rect.origin.y)
        self.width = Float(rect.width)
        self.height = Float(rect.height)
    }
}

struct TextWidgetModel: WidgetData {
    let frame: Frame
    var title: String
    var body: String
    let iconPath: String = "pencil.circle.fill"

    init(frame: Frame = Frame.zero, title: String = "", body: String = "") {
        self.frame = frame
        self.title = title
        self.body = body
    }

    func make() -> WidgetView {
        let controller = TextWidgetController()
        return TextWidgetView(controller: controller)
    }
}

struct ImageWidgetModel: WidgetData {
    let id: String
    let frame: Frame
    let iconPath: String = "camera.on.rectangle.fill"

    init(frame: Frame = Frame.zero, id: String = UUID().uuidString ) {
        self.frame = frame
        self.id = id
    }

    func make() -> WidgetView {
        return ImageWidgetView(image: Data(), id: id)
    }

}


