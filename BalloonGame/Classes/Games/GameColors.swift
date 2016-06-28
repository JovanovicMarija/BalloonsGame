//
//  GameColors.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/5/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import Foundation

class GameColors: Game {
    
    var assignedColors: [BalloonColor] = [BalloonColor.random(), BalloonColor.random(), BalloonColor.random()] {
        didSet {
            Manager.sharedInstance.delegatePointsUpdater?.balloonImages(self.assignedColors)
        }
    }
    var currentBalloonIndex: Int = 0 {
        willSet {
            Manager.sharedInstance.delegatePointsUpdater?.disableBalloonAtIndex(currentBalloonIndex)
        }
        
        didSet {
            if currentBalloonIndex == assignedColors.count {
                assignedColors = [BalloonColor.random(), BalloonColor.random(), BalloonColor.random()]
                currentBalloonIndex = 0
            }
        }
    }
    
    override func touchedBalloonWithID(id: String) {
        super.touchedBalloonWithID(id)
        
        // dohvati balon sa id
        let balloon = balloonWithID(id)
        if balloon!.color == assignedColors[currentBalloonIndex] {
            // remove balloon from scene
            Manager.sharedInstance.delegatePointsUpdater?.removeBalloonWithID(id)
            // increment points
            self.points.increment()
            // increment balloon index
            currentBalloonIndex.increment()
        } else {
            missed()
        }
    }
    
    override func missed() {
        super.missed()
    }
}
