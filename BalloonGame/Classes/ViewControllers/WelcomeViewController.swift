//
//  WelcomeViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/5/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var shouldPresentChooseLevel: Bool = true

    // IBOutlets
    @IBOutlet weak var labelWelcomeBack: UILabel! {
        didSet {
            labelWelcomeBack.textColor = UIColor.mainColor()
        }
    }
    
    @IBOutlet weak var labelUserName: UILabel! {
        didSet {
            labelUserName.textColor = UIColor.mainColor()
        }
    }
    
    @IBOutlet var labelCollectionFirstTime: [UILabel]! {
        didSet {
            for label in labelCollectionFirstTime {
                label.textColor = UIColor.mainColor()
            }
        }
    }
    
    @IBOutlet weak var buttonNewGame: RoundedButton! {
        didSet {
            buttonNewGame.backgroundColor = UIColor.mainColor()
        }
    }
    
    @IBOutlet weak var buttonChooseAnotherPlayer: RoundedButton! {
        didSet {
            buttonChooseAnotherPlayer.backgroundColor = UIColor.mainColor()
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewFirstTime: UIStackView!
    
    // properties
    private let segueIdentifier: String = "welcomeToRootSegue"
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.hidden = true
        stackViewFirstTime.hidden = true
        
        // customize message
        if let name = Manager.sharedInstance.currentUser?.name {
            labelUserName.text = name
        } else {
            buttonChooseAnotherPlayer.setTitle(NSLocalizedString("AddUser", comment: "Add User"), forState: .Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        // show appropriate view
        if Manager.sharedInstance.currentUser == nil {
            stackViewFirstTime.hidden = false
        } else {
            stackView.hidden = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape{
            stackView.spacing = 25
        } else {
            stackView.spacing = 50
        }
    }
    
    // MARK: - buttons
    
    @IBAction func buttonNewGamePressed(sender: AnyObject) {
        performSegueWithIdentifier(segueIdentifier, sender: nil)
    }
    
    @IBAction func buttonChoosePlayerPressed(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.shouldPresentChooseLevel = false
        
        performSegueWithIdentifier(segueIdentifier, sender: nil)
    }
}
