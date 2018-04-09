//
//  DBWorkerCoreData.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 27/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit
import CoreData

class DBWorkerCoreData: NSObject {

    static let shared = DBWorkerCoreData()
    
    private var dbContext : NSManagedObjectContext
    
    override init(){
        let manager = FileManager()
        dbContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        var fileURL : URL
        do {
            fileURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            fileURL = fileURL.appendingPathComponent("TasksDatabaseCoreData.sqlite")
        }
        catch {
            super.init()
            return
        }
        let storeCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: NSManagedObjectModel.mergedModel(from: [Bundle.main])!)
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: fileURL, options: [NSMigratePersistentStoresAutomaticallyOption : true])
            dbContext.persistentStoreCoordinator = storeCoordinator
        }
        catch {
            super.init()
            return
        }
        super.init()
    }
    
    func selectTasksForTable() -> [Task]{
        var resultArray = [Task]()
        var selectedTask = Task()
        let sortStatus = NSSortDescriptor.init(key: "status", ascending: true)
        let sortModified = NSSortDescriptor.init(key: "modified", ascending: true)
        let predicate = NSPredicate.init(format: "status <> %i", argumentArray: [TaskStatus.deleted.rawValue])
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Task")
        request.predicate = predicate
        request.sortDescriptors = [sortStatus, sortModified]
        let tasks : [NSManagedObject]
        do {
            tasks = try dbContext.fetch(request) as! [NSManagedObject]
        }
        catch {
            tasks = [NSManagedObject]()
        }
        for task in tasks {
            selectedTask = Task()
            selectedTask.title = task.value(forKey: "title") as? String
            selectedTask.descriptionText = task.value(forKey:"taskdescription") as? String
            selectedTask.createdDate = task.value(forKey:"created") as? String
            selectedTask.modifiedDate = task.value(forKey:"modified") as? String
            selectedTask.status = task.value(forKey:"status") as? Int
            resultArray.append(selectedTask)
        }
        return resultArray
    }
    
    func selectTask(taskCreatedDate: String) -> NSManagedObject{
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Task")
        let predicate = NSPredicate.init(format: "created = %@", argumentArray: [taskCreatedDate])
        request.predicate = predicate
        let tasks : [NSManagedObject]
        do {
            tasks = try dbContext.fetch(request) as! [NSManagedObject]
        }
        catch {
            return NSManagedObject()
        }
        guard let selectedTask = tasks.first else {
            return NSManagedObject()
        }
        return selectedTask
    }
    
    func add(newTask: Task){
        let newMOTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: dbContext)
        newMOTask.setValue(newTask.title, forKey: "title")
        newMOTask.setValue(newTask.descriptionText, forKey: "taskdescription")
        newMOTask.setValue(newTask.createdDate, forKey: "created")
        newMOTask.setValue(newTask.modifiedDate, forKey: "modified")
        newMOTask.setValue(newTask.status, forKey:"status")
        do {
            try dbContext.save()
        }
        catch {
            NSLog("Error while saving")
        }
    }
    
    func update(existingTask: Task){
        if let existingTaskCreateDate = existingTask.createdDate {
            let MOTask = self.selectTask(taskCreatedDate: existingTaskCreateDate)
            MOTask.setValue(existingTask.title, forKey:"title")
            MOTask.setValue(existingTask.descriptionText, forKey:"taskdescription")
            MOTask.setValue(existingTask.modifiedDate, forKey:"modified")
            MOTask.setValue(existingTask.status, forKey:"status")
            do {
                try dbContext.save()
            }
            catch {
                NSLog("Error while saving")
            }
        }
        else {
            return
        }
    }
    
    func remove(existingTaskCreatedDate: String){
        let MOTask = self.selectTask(taskCreatedDate: existingTaskCreatedDate)
        MOTask.setValue(TaskStatus.deleted.rawValue, forKey:"status")
        do {
            try dbContext.save()
        }
        catch {
            NSLog("Error while saving")
        }
    }
    
}
