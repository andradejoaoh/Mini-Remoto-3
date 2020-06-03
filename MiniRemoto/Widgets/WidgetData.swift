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

extension CGRect {
    init(frame: Frame) {
        self.init(x: CGFloat(frame.x), y: CGFloat(frame.y), width: CGFloat(frame.width), height: CGFloat(frame.height))
    }
}

struct TitleTextWidgetModel: WidgetData {
    var frame: Frame
    var title: String
    var iconPath: String = "pencil.circle.fill"

    init(frame: Frame = Frame.zero, title: String = "") {
        self.frame = frame
        self.title = title
    }

    func make() -> WidgetView {
        let controller = TitleTextWidgetController(model: self)
        return TitleTextWidgetView(controller: controller)
    }
}

struct BodyTextWidgetModel: WidgetData {
    var frame: Frame
    var body: String
    var iconPath: String = "3.circle.fill"

    init(frame: Frame = Frame.zero, body: String = "") {
        self.frame = frame
        self.body = body
    }
    func make() -> WidgetView {
        let controller = BodyTextWidgetController(model: self)
        return BodyTextWidgetView(controller: controller)
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
        let widget = ImageWidgetView(id: id)
        widget.view.frame = CGRect(frame: self.frame)
        return widget
    }

}


