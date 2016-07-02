//
//  GameViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 3/27/16.
//  Copyright (c) 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var labelPoints: UILabel!
    
    @IBOutlet var imageViewCollection: [UIImageView]!
        
    var game: Game = Game()
        
    var gameScene: GameScene?
    
    var timer: NSTimer!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gameScene = GameScene(fileNamed:"GameScene") {
            self.gameScene = gameScene
            
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            gameScene.scaleMode = .ResizeFill
            
            skView.presentScene(gameScene)
        }
        
        Manager.sharedInstance.delegatePointsUpdater = self
        game = Manager.sharedInstance.startGame()
        
        // gesture recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(GameViewController.handleLongPress))
        view.addGestureRecognizer(longPress)
        
        // add observers
        addObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide back button
        navigationItem.hidesBackButton = true
        
        // show number of points
        labelPoints.text = "\(game.points)p"
        
        self.performSelector(#selector(createNewBalloon), withObject: nil, afterDelay: 0.1)
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(GameViewController.createNewBalloon), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var count = NSUserDefaults.standardUserDefaults().integerForKey(userDefaults.FirstGame.rawValue)

        if count < 3 {
            let title = NSLocalizedString("AlertTitleFirstGame", comment: "Did you know?")
            let message = NSLocalizedString("AlertMessageFirstGame", comment: "To go back, long press anywhere on sky")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
            count+=1
            NSUserDefaults.standardUserDefaults().setInteger(count, forKey: userDefaults.FirstGame.rawValue)
        }
        
        Manager.sharedInstance.playBackgroundMusic()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // stop sound
        Manager.sharedInstance.stopSound()
        
        // show back button
        navigationItem.hidesBackButton = true
        //
        timer.invalidate()
        gameScene?.pauseGame()
        
        // save game to Core Data
        end()
        
        // remove observers
        removeObservers()
    }
    
    // MARK: - Notifications
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(willEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
        
    }
    
    func willEnterForeground() {
        Manager.sharedInstance.playBackgroundMusic()
    }
    
    // MARK: - gesture recognizer
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Ended {
            navigationController?.popViewControllerAnimated(true)            
        }
    }
    
    // MARK: -
    
    func createNewBalloon() {
        let balloon: Balloon = game.createNewBalloon()
        gameScene?.presentBalloon(balloon)
    }

    // MARK: - Orientation
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
}

extension GameViewController: TopViewDelegate {
    // MARK: - TopViewDelegate
    func updatePoints() {
        self.labelPoints.text = "\(game.points)p"
    }
    
    func balloonImages(names: [BalloonColor]) {
        
        for (index, name) in names.enumerate() {
            imageViewCollection[index].image = UIImage(named: name.rawValue)
            imageViewCollection[index].alpha = 1.0
        }
    }
    
    func playLetter(letter: String) {
        Manager.sharedInstance.playSoundWithName(letter, type: "m4a")
    }
    
    func disableBalloonAtIndex(index: Int) {
        imageViewCollection[index].alpha = 0.3
    }
    
    func removeBalloonWithID(id: String) {
        gameScene!.removeBalloonWithID(id)
    }
    
    func speedUpWithNewSpeed(speed: Double) {
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: #selector(GameViewController.createNewBalloon), userInfo: nil, repeats: true)
    }
    
    // method that saves current game to core data
    func end() {
        game.end()
        if let singleGame = SingleGame.saveGame(game) {
            addGameToCurrentUser(singleGame)
        }
    }
    
    private func addGameToCurrentUser(game: SingleGame) {
        
        guard let currentUserID = NSUserDefaults.standardUserDefaults().stringForKey(userDefaults.LastUser.rawValue) else {
            fatalError()
        }
        
        if let currentUser = User.userWithID(currentUserID) {
            currentUser.addGame(game)
        }
    }
}
