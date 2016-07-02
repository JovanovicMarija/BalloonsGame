//
//  AudioWord+CoreDataProperties.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/9/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AudioWord {

    @NSManaged var id: String?
    @NSManaged var letter: String?
    @NSManaged var path: String?

}
