//
//  EntityManager.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit
import CoreData

class EntityManager {
    
    static fileprivate func getManagedObjectContext() -> NSManagedObjectContext{
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDel.managedObjectContext
    }
    
    
    static func getData(_ entityName:String, predicate:NSPredicate?, sorts:[NSSortDescriptor]?) -> [NSManagedObject]{
        
        let context:NSManagedObjectContext = getManagedObjectContext()
        let entityDiscription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.entity = entityDiscription
        if(predicate != nil){
            fetchRequest.predicate = predicate
        }
        if(sorts != nil){
            fetchRequest.sortDescriptors = sorts
        }
        
        return try! context.fetch(fetchRequest)
    }
    
    static func getAData(_ entityName:String, keyColumn:String, key:String?) -> NSManagedObject{
        let context:NSManagedObjectContext = getManagedObjectContext()
        let entityDiscription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        if(key == nil){
            return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        }else{
            let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest()
            fetchRequest.entity = entityDiscription
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "%K == %@", keyColumn,key!)
            let results:[NSManagedObject] = try! context.fetch(fetchRequest)
            if(results.count > 0){
                return results[0]
            }else{
                let entity: NSManagedObject! = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
                entity.setValue(key, forKey: keyColumn)
                return entity
            }
        }
    }
    
    static func save(){
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.saveContext()
    }
    
    static func delete(_ object: NSManagedObject){
        let context: NSManagedObjectContext = getManagedObjectContext()
        context.delete(object)
        //save()
    }
    
    static func deleteAll(entityName:String){
        let context:NSManagedObjectContext = getManagedObjectContext()
        let entityDiscription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        let fetchRequest:NSFetchRequest<NSManagedObject> = NSFetchRequest()
        fetchRequest.entity = entityDiscription
        fetchRequest.includesPropertyValues = false
        let results:[NSManagedObject] = try! context.fetch(fetchRequest)
        for item in results {
            context.delete(item)
        }
        //EntityManager.save()
    }
    
}
