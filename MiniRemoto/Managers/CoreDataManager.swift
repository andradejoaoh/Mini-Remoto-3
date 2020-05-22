//
//  CoreDataManager.swift
//  MiniRemoto
//
//  Created by João Henrique Andrade on 18/05/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    private init () { }
    static let shared = CoreDataManager()
    private lazy var managedObjectContext = persistentContainer.viewContext

    
    func addTestData(){
        guard let entity = NSEntityDescription.entity(forEntityName: "TextWidget", in: managedObjectContext) else { fatalError("Could not save data") }
        
        for i in 1...25 {
            let textWidget = NSManagedObject(entity: entity, insertInto: managedObjectContext)
            textWidget.setValue("text #\(i)", forKey: "text")
            textWidget.setValue(i, forKey: "color")
        }
    }
    
    func addTextWidgetToContext(entityName: String){
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) else { fatalError("Could not save data") }
        let object = NSManagedObject(entity: entity, insertInto: managedObjectContext)
    }
    
    func addImageWidgetToContext(entityName: String, image: UIImage){
        guard let image = image.pngData() as NSData? else { return }
        
    }
    
    func fetchRequest(entityName: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            if let results = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results{
                    if let textString = result.value(forKey: "text") as? String {
                        print(textString)
                    }
                }
            }
        } catch {
            print("Could not retrieve data.")
        }
    }
    
    func deleteAllDataType(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            if let results = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results{
                    managedObjectContext.delete(result)
                }
                print("All data of object type: '\(entityName)' has been deleted.")
            }
        } catch {
            print("Could not retrieve data.")
        }
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
