//
//  GameLetters.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/5/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import Foundation

class GameLetters: Game {
    
    override func touchedBalloonWithID(id: String) {
        super.touchedBalloonWithID(id)
        Manager.sharedInstance.delegatePointsUpdater?.removeBalloonWithID(id)
        // play sound
        let balloon = balloonWithID(id)
        Manager.sharedInstance.delegatePointsUpdater?.playLetter(balloon!.letter!)
        // increment points
        self.points.increment()
    }
    
    override func missed() {
        super.missed()
    }
    
    
    override func createNewBalloon() -> Balloon {
        var newBalloon = super.createNewBalloon()
        newBalloon.letter = Character.randomLowercaseLetter()
        super.updateBalloonWithLetter(newBalloon)
        return newBalloon
    }
}