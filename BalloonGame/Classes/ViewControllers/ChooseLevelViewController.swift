//
//  ChooseLevelViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/6/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit

class ChooseLevelViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var buttonBasic: RoundedButton! {
        didSet {
            buttonBasic.backgroundColor = UIColor.mainColor()
        }
    }
    
    @IBOutlet weak var buttonColors: RoundedButton! {
        didSet {
            buttonColors.backgroundColor = UIColor.mainColor()
        }
    }
    
    @IBOutlet weak var buttonLetters: RoundedButton! {
        didSet {
            buttonLetters.backgroundColor = UIColor.mainColor()
        }
    }
    
    // properties
    private let segueIdentifier: String = "chooseLevelToGame"
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - buttons
    @IBAction func buttonBasicPressed(sender: AnyObject) {
        Manager.sharedInstance.gameMode = GameMode.Basic
        self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
    }
    
    @IBAction func buttonColorsPressed(sender: AnyObject) {
        Manager.sharedInstance.gameMode = GameMode.Colors
        self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
    }
    
    @IBAction func buttonLettersPressed(sender: AnyObject) {
        Manager.sharedInstance.gameMode = GameMode.Letters
        self.performSegueWithIdentifier(self.segueIdentifier, sender: nil)
    }
    
    // MARK: - Menu
    @IBAction func buttonMenuPressed(sender: AnyObject) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
