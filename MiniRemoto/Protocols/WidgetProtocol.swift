//
//  WidgetProtocol.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 13/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit
import CoreData

/// Model Layer
protocol Widget {
    var id: Int { get }
}

protocol CoreDataModel {
    associatedtype T : NSManagedObjectModel
    init(managedObject object: T)
    static func make(from objects: [T]) -> [Self]
}

extension CoreDataModel {
    static func make(from objects: [T]) -> [Self]  {
        var selfArr = [Self]()
        for object in objects {
            selfArr.append(Self.init(managedObject: object))
        }
        return selfArr
    }
}

/// View Layer
protocol WidgetRepresentation: AnyObject {
    var frame: CGRect { get set }
    func resize(to size: CGSize)
    func move(to position: CGPoint)
    func hide()
    func show()
    func update()
}

extension WidgetRepresentation where Self: UIViewController {
    var frame: CGRect {
        get {
            return self.view.frame
        }
        set {
            self.view.frame = newValue
            self.update()
        }
    }

    func move(to position: CGPoint) {
        self.frame.origin = position
    }

    func resize(to size: CGSize) {
        self.frame.size = size
    }
}
