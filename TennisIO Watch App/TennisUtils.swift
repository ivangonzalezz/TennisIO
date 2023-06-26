//
//  TennisUtils.swift
//  TennisIO Watch App
//
//  Created by Ivan González on 2/5/23.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TennisData")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                
                try context.save()

            } catch {
                fatalError("Error: \(error)")
            }
        }
    }
    
    
}

func formatDate(date : Date, format : String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

public class TennisData {
    let entity : String = "TennisDataEntity"
    let containerName : String = "TennisData"
    
    var persistentContainer: NSPersistentContainer!
    //var fetchRequest: NSFetchRequest<TennisDataEntity>!
    
    init() {
        self.persistentContainer = getContainer(name: self.containerName)
        //self.fetchRequest = NSFetchRequest(entityName: self.entity)
    }
    
    func getContainer(name: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    func fetchRequest() -> NSFetchRequest<TennisDataEntity> {
        return NSFetchRequest(entityName: self.entity)
    }
    
    func getEntity() -> NSEntityDescription {
        return self.persistentContainer.managedObjectModel.entitiesByName[self.entity] ?? NSEntityDescription()
    }
    
    func getContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func createObject() -> NSManagedObject {
        return NSManagedObject(entity: self.getEntity(), insertInto: self.getContext())
    }
    
    func addElement() {
        var object = createObject()
        object.setValue(1, forKey: "xRotation")
        object.setValue(1, forKey: "yRotation")
        object.setValue(1, forKey: "zRotation")
        object.setValue(NSDate(), forKey: "timestamp")
        self.save()
        print("Added element")
    }
    
    func save() {
        do {
            try getContext().save()
        } catch {
            print("Error trying to save context: \(error)")
        }
    }
    
    func count(fetchRequest : NSFetchRequest<TennisDataEntity>) -> Int {
        var count : Int = 0
        self.getContext().performAndWait {
            do {
                count = try self.getContext().count(for: fetchRequest)
            } catch {
                print("Error trying to count elements: \(error)")
            }
        }
        
        return count
    }
    
    func getElements(fetchRequest : NSFetchRequest<TennisDataEntity>) -> Array<TennisDataEntity> {
        var elements : Array<TennisDataEntity>!
        self.getContext().performAndWait {
            do {
                elements = try self.getContext().fetch(fetchRequest)
            } catch {
                print("Error trying to fetch elements: \(error)")
            }
        }
        
        return elements
    }
    
    func deleteAll() -> Bool{
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: self.getContext())
            return true
        } catch {
            print("Error trying to remove all elements: \(error)")
            return false
        }
    }
    
}
