//
//  DailyStatisticsViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 6/23/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
//import CoreData

class DailyStatisticsViewController: UIViewController {

    @IBOutlet weak var segmentFilter: UISegmentedControl! {
        didSet {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                let attributedSegmentFont = NSDictionary(object: UIFont.systemFontOfSize(25), forKey: NSFontAttributeName)
                segmentFilter.setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject], forState: .Normal)
            }
        }
    }
    
    @IBOutlet weak var segmentSort: UISegmentedControl! {
        didSet {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                let attributedSegmentFont = NSDictionary(object: UIFont.systemFontOfSize(25), forKey: NSFontAttributeName)
                segmentSort.setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject], forState: .Normal)
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor.clearColor()
            tableView.dataSource = self
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 80.0
        }
    }
    
    var tableData: [SingleGame] = [SingleGame]()
    var filteredAndSortedData: [SingleGame] = [SingleGame]()
    
    var selectedDate: NSDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredAndSortedData = tableData
        applySort(segmentSort)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "\(selectedDate.dateOnly())"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.mainColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segmented Controll
    @IBAction func applyFilter(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 3 {
            filteredAndSortedData = tableData
        } else {
            filteredAndSortedData = [SingleGame]()
            for game in tableData {
                if game.type == sender.selectedSegmentIndex {
                    filteredAndSortedData.append(game)
                }
            }
        }
        applySort(segmentSort) // this method will reload data
    }
    
    
    @IBAction func applySort(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: // starting time
            filteredAndSortedData.sortInPlace({ $0.date!.compare($1.date!) == .OrderedDescending })
        case 1: // duration
            filteredAndSortedData.sortInPlace({ Int($0.duration!) > Int($1.duration!) })
        case 2: // points
            filteredAndSortedData.sortInPlace({ Int($0.points!) > Int($1.points!) })
        default:
            fatalError()
        }
        tableView.reloadDataAnimated()
    }
}

extension DailyStatisticsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DailyStatisticsTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        let singleGame = filteredAndSortedData[indexPath.row]
        
        // imageViewGameMode
        let imageName: String
        switch GameMode(rawValue: Int(singleGame.type!))! {
        case GameMode.Basic:
            imageName = "basic"
        case GameMode.Colors:
            imageName = "colors"
        case GameMode.Letters:
            imageName = "letters"
        }
        
        cell.imageViewGameMode.image = UIImage(named: imageName)
        
        // labels
        cell.labelDuration.text = "\(singleGame.duration!)"
        
        cell.labelStartingTime.text = "\(singleGame.date!.timeOnly())"
        
        cell.labelPoints.text = "\(singleGame.points!)"
        
        return cell
    }
}
