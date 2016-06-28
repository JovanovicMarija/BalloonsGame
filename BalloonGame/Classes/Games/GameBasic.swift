//
//  GameBasic.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/5/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import Foundation

class GameBasic: Game {
    override func touchedBalloonWithID(id: String) {
        super.touchedBalloonWithID(id)
        Manager.sharedInstance.delegatePointsUpdater?.removeBalloonWithID(id)
        self.points.increment()
    }
    
    override func missed() {
        super.missed()
    }
}