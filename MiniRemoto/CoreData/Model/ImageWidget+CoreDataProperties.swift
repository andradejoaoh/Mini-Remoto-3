//
//  ImageWidget+CoreDataProperties.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 19/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageWidget> {
        return NSFetchRequest<ImageWidget>(entityName: "ImageWidget")
    }

    @NSManaged public var image: Data?
    @NSManaged public var imageOwner: Canvas?

}
