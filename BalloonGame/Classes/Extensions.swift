//
//  Extensions.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/5/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    mutating func increment() {
        self+=1
    }
    
    // including from and to numbers
    static func randomNumberBetween(from: Int, and to:Int) -> Int {
        return from + Int(arc4random_uniform(UInt32(to-from+1)))
    }
}

extension Bool {
    static func random() -> Bool {
        return arc4random_uniform(2) == 0 ? true: false
    }
}

extension String {
    static func randomLowercaseLetter() -> String {
        let lettersPath = NSBundle.mainBundle().pathForResource("letters", ofType: "plist")
        let alphabet = NSArray(contentsOfFile: lettersPath!) as! [String]
        let randomIndex = Int.randomNumberBetween(0, and: alphabet.count-1)
        return alphabet[randomIndex]
    }
}

extension UIColor {
    static func mainColor() -> UIColor {
        return UIColor(red: 0, green: 64/255, blue: 128/255, alpha: 1) // Ocean
    }
}

extension UIImage {
    func imageWithText(text: String) -> UIImage {
        // Setup the font specific variables
        let textColor: UIColor = UIColor.whiteColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 100)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(self.size)
        
        // center the text
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .Center
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle
            ]
        
        //Put the image into a rectangle as large as the original image.
        self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            rect = CGRectMake(0, 0, self.size.width, self.size.height)
        } else {
            rect = CGRectMake(0, 40, self.size.width, self.size.height)
        }
        
        //Now Draw the text into an image.
        text.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }
}

extension NSTimeInterval {
    func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        let ms = Int((interval % 1) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
}

extension NSDate {
    func yearsFromDate(fromDate: NSDate, toDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.Year, fromDate: fromDate, toDate: toDate, options: [])
        let years = dateComponents.year
//        print("Years: \(years)")
        return years
    }
    
    func monthsFromDate(fromDate: NSDate, toDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.Month, fromDate: fromDate, toDate: toDate, options: [])
        let months = dateComponents.month
//        print("Months: \(months)")
        return months
    }
    
    func daysFromDate(fromDate: NSDate, toDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.Day, fromDate: fromDate, toDate: toDate, options: [])
        let days = dateComponents.day
//        print("Days: \(days)")
        return days
    }
    
    func hoursFromDate(fromDate: NSDate, toDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.Hour, fromDate: fromDate, toDate: toDate, options: [])
        let hours = dateComponents.hour
//        print("Hours: \(hours)")
        return hours
    }
    
    func minutesFromDate(fromDate: NSDate, toDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.Minute, fromDate: fromDate, toDate: toDate, options: [])
        let minutes = dateComponents.minute
//        print("Minutes: \(minutes)")
        return minutes
    }
    
    func secondsFromDate(fromDate: NSDate, toDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.Second, fromDate: fromDate, toDate: toDate, options: [])
        let seconds = dateComponents.second
//        print("Seconds: \(seconds)")
        return seconds
    }
    
    func dateOnly() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter.stringFromDate(self)
    }
    
    func timeOnly() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(self, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        return timestamp
    }
}

extension UITableView {
    func reloadDataAnimated() {
        UIView.animateWithDuration(0.25, animations: {
            self.alpha = 0
        }) { _ in
            self.reloadData()
            UIView.animateWithDuration(0.25, animations: {
                self.alpha = 1
            })
        }
    }
}

extension UINavigationController {
    public override func shouldAutorotate() -> Bool {
        if visibleViewController is TutorialViewController {
            return false
        } else {
            return true
        }
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations())!
    }
}