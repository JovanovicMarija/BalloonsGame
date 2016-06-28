//
//  SingleGame.swift
//  
//
//  Created by Marija Jovanovic on 6/13/16.
//
//

import Foundation
import CoreData
import UIKit


class SingleGame: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    
    static func allGamesForUserWithID(id: String) -> [SingleGame] {
        
        var games: [SingleGame] = [SingleGame]()
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // 2
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        // 3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let user = results[0] as! User
            
            games = user.arraySingleGames!.allObjects as! [SingleGame]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return games
    }
    
}
