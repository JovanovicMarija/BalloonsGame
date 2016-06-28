//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var photo: NSData?
    @NSManaged var arrayAudioWords: NSOrderedSet?
    @NSManaged var arraySingleGames: NSSet?

}
