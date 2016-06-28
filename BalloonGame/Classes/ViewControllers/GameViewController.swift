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
    
    @IBOutlet var imageViewCollection: [UIImageView]! {
        didSet {
            for image in imageViewCollection {
                image.hidden = true
            }
        }
    }
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

    }
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait")
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide back button
        navigationItem.hidesBackButton = true
        
        // show number of points
        labelPoints.text = "\(game.points)p"
        
        self.performSelector(#selector(createNewBalloon), withObject: nil, afterDelay: 0.1)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.7, target: self, selector: #selector(GameViewController.createNewBalloon), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Manager.sharedInstance.playAmbientMusic()
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
        for imageView in imageViewCollection {
            imageView.hidden = true
            imageView.alpha = 1.0
        }
        
        for (index, name) in names.enumerate() {
            imageViewCollection[index].hidden = false
            imageViewCollection[index].image = UIImage(named: name.rawValue)
        }
    }
    
    func playLetter(letter: Character) {
        Manager.sharedInstance.playSoundWithName(String(letter), type: "m4a")
    }
    
    func disableBalloonAtIndex(index: Int) {
        imageViewCollection[index].alpha = 0.5
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
        if let singleGame = saveGame() {
            addGameToCurrentUser(singleGame)
        }
    }
    
    private func saveGame() -> SingleGame? {
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
    
    private func addGameToCurrentUser(game: SingleGame) {
        // TODO: - implement
        
        guard let currentUserID = NSUserDefaults.standardUserDefaults().stringForKey(userDefaults.LastUser.rawValue) else {
            fatalError()
        }
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // 2
        let fetchRequest = NSFetchRequest(entityName: "User")
        let predicate = NSPredicate(format: "id == %@", currentUserID)
        fetchRequest.predicate = predicate
        // 3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let user = results[0] as! User
            
            var existingGames = user.arraySingleGames!.allObjects as! [SingleGame]
            existingGames.append(game)
            user.arraySingleGames = NSSet(array: existingGames)
            
            // 4
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
    }
}
