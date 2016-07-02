//
//  GameUnlimited.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/5/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import Foundation

struct Balloon {
    let id: String = NSUUID().UUIDString
    let color: BalloonColor = BalloonColor.randomWithWeight()
    var letter: String?
}

protocol BalloonProtocol {
    func createNewBalloon() -> Balloon
    func touchedBalloonWithID(id: String)
    func missed()
}

class Game: BalloonProtocol {
    var points: Int = 0 {
        willSet {
            if points/10 != newValue/10 {
                level+=1
            }
        }
        
        didSet {
            Manager.sharedInstance.delegatePointsUpdater?.updatePoints()
        }
    }
    var misses: Int = 0
    var level: Int = 0 {
        didSet {
            if level < 10 {
                speed-=0.1
                Manager.sharedInstance.delegatePointsUpdater?.speedUpWithNewSpeed(speed)
            }
        }
    }
    
    private var speed = 2.0
    
    var duration: NSTimeInterval = 0
    
    var date = NSDate()
    
    var allBalloons: [Balloon] = [Balloon]()
    
    func touchedBalloonWithID(id: String) {
        
    }
    
    func missed() {
        self.misses.increment()
//        print("misses: ", self.misses)
        
        // play missed sound
        Manager.sharedInstance.playErrorSound()
    }
    
    func createNewBalloon() -> Balloon {
        let newBalloon = Balloon()
        allBalloons.append(newBalloon)
        return newBalloon
    }
    
    func balloonWithID(id: String) -> Balloon? {
        for balloon in allBalloons {
            if balloon.id == id {
                return balloon
            }
        }
        return nil
    }
    
    func updateBalloonWithLetter(balloon: Balloon) {
        for (index, currentBalloon) in allBalloons.enumerate() {
            if balloon.id == currentBalloon.id {
                allBalloons[index].letter = balloon.letter
                return
            }
        }
    }
    
    func pause() {
        duration += NSDate().timeIntervalSinceDate(date)
    }
    
    func resume() {
        date = NSDate()
    }
    
    func end() {
        duration += NSDate().timeIntervalSinceDate(date)
    }
}
