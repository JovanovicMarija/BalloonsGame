//
//  AllChildrenViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/6/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
import CoreData

class AllChildrenViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.hidden = true
            tableView.backgroundColor = UIColor.clearColor()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var labelNoUsers: UILabel! {
        didSet {
            labelNoUsers.hidden = true
            
            labelNoUsers.textColor = UIColor.mainColor()
        }
    }
    
    @IBOutlet var buttonMenu: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)

    // properties
    var users: [User] = [User]()
    var filteredUsers: [User] = [User]()
    private let segueIdentifier = "allChildrenToSingleChildSegue"
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.backgroundColor = UIColor.clearColor()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.backgroundImage = UIImage()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let users = User.allUsers() {
            self.users = users
            tableView.reloadData()
            tableView.hidden = false
            labelNoUsers.hidden = true
            self.navigationItem.leftBarButtonItem = buttonMenu
        } else { // there are no users
            tableView.hidden = true
            labelNoUsers.hidden = false
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    // MARK: - Menu
    
    @IBAction func buttonMenuPressed(sender: AnyObject) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    // MARK: - others
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = users.filter { user in
            return user.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? AddChildViewController {
            vc.existingUser = sender as? User
        }
    }

}

extension AllChildrenViewController: UITableViewDataSource {
    // MARK: - TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user: User
        if searchController.active && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AllChildrenTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.imageViewPhoto.image = UIImage(data: user.photo!)
        cell.labelName.text = user.name
        cell.labelScore.text = "\(user.totalPoints())"
        return cell
    }
}

extension AllChildrenViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // chosen user
        let chosenUser = users[indexPath.row]
        // remember user as last user in userDefaults
        NSUserDefaults.standardUserDefaults().setObject(chosenUser.id, forKey: userDefaults.LastUser.rawValue)
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let alert = UIAlertController(title: "Are you sure you want to delete user?", message: "This will delete all related data and statistics. This action cannot be undone.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in
                // hide delete button
                tableView.editing = false
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: { _ in
                // TODO:
                // First: delete all games associate to user id
                // Second: delete all sounds
                // Lastly: delete user
                
                // delete all games
                self.users[indexPath.row].deleteAllGames()
                
                // remove from core data
                self.users[indexPath.row].deleteUser()
                
                // remove from data source
                self.users.removeAtIndex(indexPath.row)
                // reload table
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                if self.users.count == 0 {
                    self.tableView.hidden = true
                    // animate appearence of label
                    self.labelNoUsers.alpha = 0.0
                    self.labelNoUsers.hidden = false
                    UIView.animateWithDuration(0.5, animations: {
                        self.labelNoUsers.alpha = 1.0
                        }, completion: nil)
                }
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { [unowned self] (action, indexPath) in
            self.performSegueWithIdentifier(self.segueIdentifier, sender: self.users[indexPath.row])
        }
        
        edit.backgroundColor = UIColor.mainColor()
        
        return [delete, edit]

    }
}

extension AllChildrenViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
