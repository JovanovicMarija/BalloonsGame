//
//  User.swift
//  
//
//  Created by Marija Jovanovic on 6/13/16.
//
//

import Foundation
import CoreData
import UIKit

class User: NSManagedObject {

    static func allUsers() -> [User]? {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as? [User]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    static func userWithID(id: String) -> User? {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // 2
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        // 3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            return results[0] as? User
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func deleteUser() {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        // 2
        managedContext.deleteObject(self)
        //3
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllGames() {
        if self.arraySingleGames == nil {
            return
        }
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        // 2
        
        for game in self.arraySingleGames! {
            managedContext.deleteObject(game as! SingleGame)
        }
        
        //3
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func addGame(game: SingleGame) {
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // 2
        var existingGames = self.arraySingleGames!.allObjects as! [SingleGame]
        existingGames.append(game)
        self.arraySingleGames = NSSet(array: existingGames)
        
        // 3
        do {
            // 4
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func totalPoints() -> Int {
        if self.arraySingleGames == nil {
            return 0
        }
        
        var result = 0
        for game in self.arraySingleGames! {
            result+=Int((game as! SingleGame).points!)
        }
        return result
    }
    
    func totalGamesPlayes() -> Int {
        return self.arraySingleGames?.count ?? 0
    }
    
    func dateOfLastPlayedGame() -> NSDate {
        var result = NSDate(timeIntervalSince1970: 0)
        if self.arraySingleGames != nil {
            for game in self.arraySingleGames! {
                if game.date!.compare(result) == .OrderedDescending {
                    result = game.date!
                }
            }
        }
        return result
    }
    
}
