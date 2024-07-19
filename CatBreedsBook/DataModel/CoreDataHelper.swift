//
//  CoreDataHelper.swift
//  CatBreedsBook
//
//  Created by Vitaliy Bal on 18.07.2024.
//

import Foundation
import CoreData

protocol CoreDataHelperProtocol {
    
    var context: NSManagedObjectContext { get }
    
    func saveContext()
}

final class CoreDataHelper: CoreDataHelperProtocol {
    
    private let persistentContainer: NSPersistentContainer

    init(containerName: String) {
        self.persistentContainer = NSPersistentContainer(name: containerName)
        self.persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
