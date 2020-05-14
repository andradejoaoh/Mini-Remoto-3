//
//  TextWidgetModel.swift
//  MiniRemoto
//
//  Created by Artur Carneiro on 14/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import CoreData

class TextWidgets: NSManagedObjectModel {
    var id: Int = 0
    var title: String = ""
    var body: String = ""
}

struct TextWidgetModel: Widget {
    private(set) var id: Int
    var title: String
    var body: String
}

extension TextWidgetModel: CoreDataModel {
    typealias T = TextWidgets

    init(managedObject object: TextWidgets) {
        self.id = object.id
        self.title = object.title
        self.body = object.body
    }
}

