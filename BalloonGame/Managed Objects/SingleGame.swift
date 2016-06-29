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
        
        if let user = User.userWithID(id) {
            games = user.arraySingleGames!.allObjects as! [SingleGame]
        }
        
        return games
    }
    
    static func saveGame(game: Game) -> SingleGame? {
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("SingleGame",
                                                        inManagedObjectContext:managedContext)
        
        let singleGame = NSManagedObject(entity: entity!,
                                         insertIntoManagedObjectContext: managedContext) as! SingleGame
        
        //3
        singleGame.id = NSUUID().UUIDString
        singleGame.type = Manager.sharedInstance.gameMode.rawValue
        singleGame.duration = game.duration
        singleGame.date = game.date
        singleGame.points = game.points
        
        //4
        do {
            try managedContext.save()
            return singleGame
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return nil
    }
}
