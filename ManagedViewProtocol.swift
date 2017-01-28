//
//  ManagedObjectContextProtocol.swift
//  Block
//
//  Created by Dan Beaulieu on 12/29/16.
//  Copyright © 2016 Dan Beaulieu. All rights reserved.
//

import Foundation
import CoreData

public typealias DataContext = NSManagedObjectContext

protocol ManagedObjectContextProtocol: class {
    var moc: NSManagedObjectContext! { get set }
}

extension ManagedObjectContextProtocol {
    func checkManagedObjectContext(_ name : String) {
        if moc == nil {
           assertionFailure("\(name) is missing the managed object context.")
        }
    }
    
    func addContextNotificationObservers(_ moc : DataContext) {
        print("adding observers")
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: nil, queue: nil) { note in
            if let updated = note.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updated.count > 0 {
                print("updated: \(updated)")
            }
            
            if let deleted = note.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>, deleted.count > 0 {
                print("deleted: \(deleted)")
            }
            
            if let inserted = note.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserted.count > 0 {
                print("inserted: \(inserted)")
            }
        }
        
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextWillSave, object: nil, queue: nil) { note in
            print("managedObjectContextWillSave")
            guard let userInfo = note.userInfo else { return }
            print(userInfo)
        }
        
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: nil, queue: nil) { note in
            print("managedObjectContextDidSave")
            guard let userInfo = note.userInfo else { return }
            print(userInfo)
        }
    }
    
    func removeContextNotificationObservers(_ moc : DataContext) {
        print("removing observers")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: moc)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextWillSave, object: moc)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
        
    }
 
}
