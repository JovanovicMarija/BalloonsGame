//
//  SingleGame+CoreDataProperties.swift
//  
//
//  Created by Marija Jovanovic on 6/13/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SingleGame {

    @NSManaged var id: String?
    @NSManaged var type: NSNumber?
    @NSManaged var points: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var duration: NSNumber?

}
