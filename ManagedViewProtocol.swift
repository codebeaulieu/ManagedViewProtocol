//
//  ManagedObserverProtocol.swift
//  Block
//
//  Created by Dan Beaulieu on 1/29/17.
//  Copyright © 2017 Dan Beaulieu. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObserverProtocol : class {
    // since we're using block syntax for our NotificationCenter observers, we'll need a way to hold a reference to them
    // so that we can release them
    var didChangeNotification : NSObjectProtocol? { get set }
    var willSaveNotification : NSObjectProtocol? { get set }
    var didSaveNotification : NSObjectProtocol? { get set }
}

extension ManagedObserverProtocol {

    
    func addContextNotificationObservers(_ moc : DataContext) {
        print("adding observers")
        didChangeNotification = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: moc, queue: nil) { note in
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
        
        
        willSaveNotification = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextWillSave, object: moc, queue: nil) { note in
            print("managedObjectContextWillSave")
            guard let userInfo = note.userInfo else { return }
            print(userInfo)
        }
        
        didSaveNotification = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: moc, queue: nil) { note in
            print("managedObjectContextDidSave")
            guard let userInfo = note.userInfo else { return }
            print(userInfo)
        }
    }
    
    func removeContextNotificationObservers() {
        print("removing observers")
        if let didChange = didChangeNotification {
            NotificationCenter.default.removeObserver(didChange)
        }
        
        if let willSave = willSaveNotification {
            NotificationCenter.default.removeObserver(willSave)
        }
        
        if let didSave = didSaveNotification {
            NotificationCenter.default.removeObserver(didSave)
        }
    }
 
}
