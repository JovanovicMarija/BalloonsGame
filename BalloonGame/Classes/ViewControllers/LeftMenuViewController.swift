//
//  LeftMenuViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/11/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit

class LeftMenuViewController: UITableViewController {
    
    var currentIndexPath: NSIndexPath!
    
    func setUp() {
        let row = (UIApplication.sharedApplication().delegate as! AppDelegate).shouldPresentChooseLevel ? 0 : 1
        currentIndexPath = NSIndexPath(forRow: row, inSection: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inset: UIEdgeInsets
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            inset = UIEdgeInsetsMake(20, 0, 0, 0)
        } else {
            inset = UIEdgeInsetsMake(50, 0, 0, 0)
        }
        
        self.tableView.contentInset = inset

        tableView.backgroundColor = UIColor.mainColor()
        
        setUp()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // set filled picture
        let cell = tableView.cellForRowAtIndexPath(currentIndexPath)
        let imageName: String
        switch currentIndexPath.row {
        case 0:
            imageName = "menuGameFilled"
        case 1:
            imageName = "menuUserFilled"
        case 2:
            imageName = "menuStatisticsFilled"
        case 3:
            imageName = "menuTutorialFilled"
        default:
            fatalError("index path out of bounderies")
        }
        cell?.imageView?.image = UIImage(named: imageName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // remove old filled picture
        let oldCell = tableView.cellForRowAtIndexPath(currentIndexPath)
        let oldImageName: String
        switch currentIndexPath.row {
        case 0:
            oldImageName = "menuGameLined"
        case 1:
            oldImageName = "menuUserLined"
        case 2:
            oldImageName = "menuStatisticsLined"
        case 3:
            oldImageName = "menuTutorialLined"
            default:
                fatalError("index path out of bounderies")
        }
        oldCell?.imageView?.image = UIImage(named: oldImageName)
        
        // set new index
        currentIndexPath = indexPath
        
        // set new filled picture
        let newCell = tableView.cellForRowAtIndexPath(currentIndexPath)
        let newImageName: String
        switch currentIndexPath.row {
        case 0:
            newImageName = "menuGameFilled"
        case 1:
            newImageName = "menuUserFilled"
        case 2:
            newImageName = "menuStatisticsFilled"
        case 3:
            newImageName = "menuTutorialFilled"
        default:
            fatalError("index path out of bounderies")
        }
        newCell?.imageView?.image = UIImage(named: newImageName)
        
        
        switch indexPath.row {
        case 0:
            self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewControllerWithIdentifier("chooseLevelViewController")), animated: true)
            self.sideMenuViewController.hideMenuViewController()
        case 1:
            self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewControllerWithIdentifier("allChildrenViewController")), animated: true)
            self.sideMenuViewController.hideMenuViewController()
        case 2:
            self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewControllerWithIdentifier("statisticsViewController")), animated: true)
            self.sideMenuViewController.hideMenuViewController()
        case 3:
            self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewControllerWithIdentifier("tutorialViewController")), animated: true)
            self.sideMenuViewController.hideMenuViewController()
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return 75
        } else {
            return 100
        }
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
