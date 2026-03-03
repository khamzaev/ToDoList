//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by khamzaev on 01.03.2026.
//


import CoreData


final class CoreDataStack {
    let container: NSPersistentContainer
    
    
    init(modelName: String, inMemory: Bool = false) {
        container = NSPersistentContainer(name: modelName)
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores {_, error in
            if let error {
                fatalError("CoreData load error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func performBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
        }
    }
}
