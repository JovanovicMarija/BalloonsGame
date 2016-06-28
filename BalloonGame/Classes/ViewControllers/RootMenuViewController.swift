//
//  RootMenuViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/11/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
import RESideMenu

class RootMenuViewController: RESideMenu, RESideMenuDelegate {
    
    override func awakeFromNib() {
        self.menuPreferredStatusBarStyle = .LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0, 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.shouldPresentChooseLevel {
            self.contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("contentNavigationController")
        } else {
            self.contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("allUsersNavigationController")
        }
        
        self.leftMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("leftMenuViewController")
        self.backgroundImage = UIImage(named: "background")
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SideMenu Delegate
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        
    }

    func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        
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
