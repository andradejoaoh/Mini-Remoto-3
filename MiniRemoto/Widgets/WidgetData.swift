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
        return UIImage(named: self.iconPath) ?? UIImage()
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
    var iconPath: String = "TitleWidgetIcon-main"

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
    var iconPath: String = "TextWidgetIcon-main"

    init(frame: Frame = Frame.zero, body: String = "") {
        self.frame = frame
        self.body = body
    }
    func make() -> WidgetView {
        let controller = BodyTextWidgetController(model: self)
        return BodyTextWidgetView(controller: controller)
    }

    
}

func genID() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let now = Date()
    let dateString = formatter.string(from:now)
    return dateString
}

struct ImageWidgetModel: WidgetData {
    let id: String
    let frame: Frame
    let iconPath: String = "ImageWidgetIcon-main"

    init(frame: Frame = Frame.zero, id: String = UUID().uuidString) {
        self.frame = frame
        self.id = id
    }

    func make() -> WidgetView {
        let widget = ImageWidgetView(id: self.id)
        widget.view.frame = CGRect(frame: self.frame)
        return widget
    }

}


