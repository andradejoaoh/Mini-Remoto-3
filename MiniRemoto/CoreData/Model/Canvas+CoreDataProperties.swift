//
//  Canvas+CoreDataProperties.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 19/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//
//

import Foundation
import CoreData


extension Canvas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Canvas> {
        return NSFetchRequest<Canvas>(entityName: "Canvas")
    }

    @NSManaged public var name: String?
    @NSManaged public var textWidgets: NSSet?
    @NSManaged public var imageWidgets: ImageWidget?

}

// MARK: Generated accessors for textWidgets
extension Canvas {

    @objc(addTextWidgetsObject:)
    @NSManaged public func addToTextWidgets(_ value: TextWidget)

    @objc(removeTextWidgetsObject:)
    @NSManaged public func removeFromTextWidgets(_ value: TextWidget)

    @objc(addTextWidgets:)
    @NSManaged public func addToTextWidgets(_ values: NSSet)

    @objc(removeTextWidgets:)
    @NSManaged public func removeFromTextWidgets(_ values: NSSet)

}
