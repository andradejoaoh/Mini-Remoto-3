//
//  TextWidget+CoreDataProperties.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 19/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//
//

import Foundation
import CoreData


extension TextWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextWidget> {
        return NSFetchRequest<TextWidget>(entityName: "TextWidget")
    }

    @NSManaged public var color: Float
    @NSManaged public var text: String?
    @NSManaged public var textOwner: Canvas?

}
