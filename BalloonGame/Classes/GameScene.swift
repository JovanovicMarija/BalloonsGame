//
//  GameScene.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 3/27/16.
//  Copyright (c) 2016 Marija Jovanovic. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {

    var texturesClouds: [SKTexture] = [SKTexture]()
    
    let background: SKSpriteNode = SKSpriteNode(imageNamed: "sky")
    
    private var timer: NSTimer!
    
    let maxFromHeightAndWidth = max(UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width)

    override func didMoveToView(view: SKView) {
        
        //adding the background
        background.zPosition = 1
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))
        self.addChild(background)
        
        // clouds
        //load clouds
        let cloudsAtlas: SKTextureAtlas = SKTextureAtlas(named: "Clouds")
        let textureNamesClouds: [String] = cloudsAtlas.textureNames
        for name in textureNamesClouds {
            let texture: SKTexture = cloudsAtlas.textureNamed(name)
            texturesClouds.append(texture)
        }
        
        
        //random Clouds
        presentCloud()
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(presentCloud), userInfo: nil, repeats: true)
    }
    
    override func didChangeSize(oldSize: CGSize) {
        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))
    }
    
    func presentCloud() {
        
        let whichCloud: Int = Int.randomNumberBetween(0, and: 3)
        let cloud: SKSpriteNode = SKSpriteNode(texture: texturesClouds[whichCloud])
        
        let beginX: CGFloat
        let endX: CGFloat
        
        let randomClouds: Int = Int.randomNumberBetween(0, and: 1)
        if randomClouds == 1 {
            beginX = maxFromHeightAndWidth+cloud.size.height/2
            endX = 0-cloud.size.height
        } else {
            beginX = 0-cloud.size.height
            endX = maxFromHeightAndWidth+cloud.size.height/2
        }
        
        let randomYAxix: CGFloat = CGFloat(Int.randomNumberBetween(0, and: Int(maxFromHeightAndWidth)))
        cloud.position = CGPointMake(beginX, randomYAxix)
        // clouds are sometimes above sky and below balloons
        //        and sometimes above sky and above balloons
        cloud.zPosition = CGFloat(Int.randomNumberBetween(2, and: 3))

        let randomTimeCloud: NSTimeInterval = NSTimeInterval(Int.randomNumberBetween(9, and: 19))
        
        let move: SKAction = SKAction.moveTo(CGPointMake(endX, randomYAxix), duration: randomTimeCloud)
        let remove: SKAction = SKAction.removeFromParent()
        cloud.runAction(SKAction.sequence([move, remove]))
        self.addChild(cloud)
    }
    
    func presentBalloon(balloon: Balloon) {
        
        let sprite: SKSpriteNode
        if let letter = balloon.letter {
            sprite = SKSpriteNode(texture: SKTexture(image: UIImage(named: balloon.color.rawValue)!.imageWithText(String(letter))))
        } else {
            sprite = SKSpriteNode(texture: SKTexture(image: UIImage(named: balloon.color.rawValue)!))
        }
        
        sprite.name = balloon.id
        
        let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.size.width - sprite.size.width)))
        let y: CGFloat = maxFromHeightAndWidth + sprite.size.height
        sprite.position = CGPointMake(sprite.size.width/2 + randomX, -sprite.size.height)
        
        // balloons are sometimes above sky and below clouds
        //          and sometimes above sky and above clouds
        sprite.zPosition = CGFloat(Int.randomNumberBetween(2, and: 3))
        
        let randomDuration: NSTimeInterval = NSTimeInterval(Int.randomNumberBetween(9, and: 19))

        let action = SKAction.moveToY(y, duration: randomDuration)
        let actionRemove = SKAction.removeFromParent()
        sprite.runAction(SKAction.sequence([action, actionRemove]))
        
        self.addChild(sprite)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name {
            Manager.sharedInstance.touchedBalloonWithID(name)
        } else {
            Manager.sharedInstance.missed()
        }
    }
    
    func removeBalloonWithID(id: String) {
        let balloonNode: SKSpriteNode = childNodeWithName(id) as! SKSpriteNode
        balloonNode.removeFromParent()
    }
    
    func pauseGame() {
        timer.invalidate()
    }
}
