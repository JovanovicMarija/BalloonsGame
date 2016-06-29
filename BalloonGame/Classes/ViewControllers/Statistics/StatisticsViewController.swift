//
//  StatisticsViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 6/13/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class StatisticsViewController: UIViewController {

    @IBOutlet weak var calendarWithGames: FSCalendar!
    
    @IBOutlet weak var labelBestScore: UILabel!
    
    @IBOutlet weak var labelTotalGamesPlayed: UILabel!
    
    
    @IBOutlet weak var buttonSeeAllGames: RoundedButton!
    
    var selectedDate: NSDate = NSDate()
    
    var games: [SingleGame] = [SingleGame]()
    var datesWithEvents: [NSDate] = [NSDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // games for current user
        guard let currentUserID = NSUserDefaults.standardUserDefaults().stringForKey(userDefaults.LastUser.rawValue) else {
            fatalError()
        }
        
        games = SingleGame.allGamesForUserWithID(currentUserID)
        refreshDatesWithEvents()
        
        // calendar
        calendarWithGames.dataSource = self
        calendarWithGames.delegate = self
        
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        let dateOnly = NSCalendar.currentCalendar().dateFromComponents(components)
        updateViewsForSelectedDate(dateOnly!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - helper methods
    func refreshDatesWithEvents() {
        datesWithEvents = [NSDate]()
        for game in games {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day, .Month, .Year], fromDate: game.date!)
            let dateOnly = NSCalendar.currentCalendar().dateFromComponents(components)
            
            if !datesWithEvents.contains(dateOnly!) {
                datesWithEvents.append(dateOnly!)
            }
        }
    }
    
    func bestScoreAndTotalGamesPlayedForDate(date: NSDate) -> (bestScore: Int, totalGamesPlayed: Int) {
        
        var bestScore = 0
        var totalGamesPlayed = 0
        for game in games {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day, .Month, .Year], fromDate: game.date!)
            let dateOnly = NSCalendar.currentCalendar().dateFromComponents(components)
            
            if dateOnly!.isEqualToDate(date) {
                bestScore = max(bestScore, Int(game.points!))
                totalGamesPlayed+=1
                
            }
        }
        
        return (bestScore, totalGamesPlayed)
    }
    
    func tableDataForDate(date: NSDate) -> [SingleGame] {
        
        var tableData = [SingleGame]()
        for game in games {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day, .Month, .Year], fromDate: game.date!)
            let dateOnly = NSCalendar.currentCalendar().dateFromComponents(components)
            
            if dateOnly!.isEqualToDate(date) {
                tableData.append(game)
                
            }
        }
        
        return tableData
    }
    
    func updateViewsForSelectedDate(date: NSDate) {
        // save date in order to present it on the following (DailyStatistics) view controller
        selectedDate = date
        
        // set best score and total games played
        let result = bestScoreAndTotalGamesPlayedForDate(date)
        // best score
        labelBestScore.text = "\(result.bestScore)"
        // total games played
        labelTotalGamesPlayed.text = "\(result.totalGamesPlayed)"
        // if needed, change appearence
        if result.totalGamesPlayed == 0 {
            labelBestScore.textColor = UIColor.lightGrayColor()
            labelTotalGamesPlayed.textColor = UIColor.redColor()
            buttonSeeAllGames.enabled = false
            buttonSeeAllGames.alpha = 0.3
        } else {
            labelBestScore.textColor = UIColor.mainColor()
            labelTotalGamesPlayed.textColor = UIColor.mainColor()
            buttonSeeAllGames.enabled = true
            buttonSeeAllGames.alpha = 1.0
        }
    }
    
    // MARK: - Menu
    
    @IBAction func buttonMenuPressed(sender: AnyObject) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destinationViewController.isKindOfClass(DailyStatisticsViewController) {
            let vc = segue.destinationViewController as! DailyStatisticsViewController
            vc.tableData = tableDataForDate(selectedDate)
            vc.selectedDate = selectedDate
        }
    }
}

extension StatisticsViewController: FSCalendarDelegate {
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        
        updateViewsForSelectedDate(date)
        
    }
}

extension StatisticsViewController: FSCalendarDataSource {
    
    func calendar(calendar: FSCalendar, hasEventForDate date: NSDate) -> Bool {
        return datesWithEvents.contains(date)
    }
    
    func calendar(calendar: FSCalendar, shouldSelectDate date: NSDate) -> Bool {
        return date.compare(NSDate()) == .OrderedAscending
    }
    
}