//
//  DataController.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/16/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import Foundation
import CoreData

// The DataController class provides objects and functions needed to persist data and to load persisted data.  The code below as provided by Udacity in the Mooskine example app provided as part of the Data Persistence Course of the iOS Developer Nanodegree.

class DataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores() { storeDescription, error in
            
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            completion?()
        }
    }
}
