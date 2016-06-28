//
//  Manager.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/2/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum userDefaults: String {
    case LastUser = "lastUser"
}

class Manager {
    
    var currentUser: User?
    
    static let sharedInstance = Manager()
    private init() {}
    
    var delegatePointsUpdater: TopViewDelegate? = nil
        
    var gameMode: GameMode = GameMode.Colors
//    var currentGame: BalloonProtocol?
    var currentGame: Game?
    
    var audioPlayer = AVAudioPlayer()

    // MARK: - methods
    func startGame() -> Game {
        switch gameMode {
        case .Basic:
            self.currentGame = GameBasic()
        case .Colors:
            self.currentGame = GameColors()
            delegatePointsUpdater?.balloonImages((self.currentGame as! GameColors).assignedColors)
        case .Letters:
            self.currentGame = GameLetters()
        }
        return self.currentGame!
    }
    
    func createNewBalloon() -> Balloon {
        return self.currentGame!.createNewBalloon()
    }
    
    func touchedBalloonWithID(id: String) {
        self.currentGame!.touchedBalloonWithID(id)
    }
    
    func missed() {
        self.currentGame!.missed()
    }
    
    func playSoundWithName(name: String, type: String) {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: type)!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: coinSound)
        } catch {
            print("playLetter")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func playAmbientMusic() {
        let ambientMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gameSong1", ofType: "mp3")!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: ambientMusic)
        } catch {
            print("ambientMusic")
        }
        audioPlayer.numberOfLoops = -1 // indefinite number of loops
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func playErrorSound() {
        let errorSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("error", ofType: "mp3")!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: errorSound)
        } catch {
            print("errorSound")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func stopSound() {
        audioPlayer.stop()
    }
}

enum GameMode: Int {
    case Basic = 0
    case Colors = 1
    case Letters = 2
}

enum BalloonColor: String {
    case blue = "blue"
    case green = "green"
    case lightGreen = "lightGreen"
    case lightPurple = "lightPurple"
    case orange = "orange"
    case pink = "pink"
    case purple = "purple"
    case red = "red"
    case yellow = "yellow"
    
    static let allValues = [blue, green, lightGreen, lightPurple, orange, pink, purple, red, yellow]
    
    static func randomWithWeight() -> BalloonColor {

        if Manager.sharedInstance.gameMode == .Colors {
            var weight: [BalloonColor: Int] = [BalloonColor: Int]()
            let count = 3+BalloonColor.allValues.count
//            let singleWeight = 1/count
            for color in BalloonColor.allValues {
                weight[color] = 1 //singleWeight
            }
            
            let currentIndex = (Manager.sharedInstance.currentGame as! GameColors).currentBalloonIndex
            weight[(Manager.sharedInstance.currentGame as! GameColors).assignedColors[currentIndex]]!+=4
            
            
            let randomIndex = Int(arc4random_uniform(UInt32(count)))
            var weightSum = 0
            for color in BalloonColor.allValues {
                weightSum+=weight[color]!
                if randomIndex <= weightSum {
                    return color
                }
            }
            
//            var rand = function(min, max) {
//                return Math.random() * (max - min) + min;
//            };
//            
//            var getRandomItem = function(list, weight) {
//                var total_weight = weight.reduce(function (prev, cur, i, arr) {
//                    return prev + cur;
//                    });
//                
//                var random_num = rand(0, total_weight);
//                var weight_sum = 0;
//                //console.log(random_num)
//                
//                for (var i = 0; i < list.length; i++) {
//                    weight_sum += weight[i];
//                    weight_sum = +weight_sum.toFixed(2);
//                    
//                    if (random_num <= weight_sum) {
//                        return list[i];
//                    }
//                }
//                
//                // end of function
//            };
        } else {
            let count = BalloonColor.allValues.count
            let randomIndex = Int(arc4random_uniform(UInt32(count)))
            return allValues[randomIndex]
        }
        let count = BalloonColor.allValues.count
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return allValues[randomIndex]
    }
    
    static func random() -> BalloonColor {
        let count = BalloonColor.allValues.count
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return allValues[randomIndex]
    }
}

protocol TopViewDelegate {
    func updatePoints()
    func balloonImages(names: [BalloonColor])
    func playLetter(letter: Character)
    func disableBalloonAtIndex(index: Int)
    func removeBalloonWithID(id: String)
    func speedUpWithNewSpeed(speed: Double)
}