//
//  AllChildrenTableViewCell.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/6/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit

class AllChildrenTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView! {
        didSet {
            imageViewPhoto.clipsToBounds = true
            imageViewPhoto.layer.cornerRadius = imageViewPhoto.frame.size.height/2
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTotalGamePlayed: UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                imageViewPhoto.image = UIImage(data: user.photo!)
                labelName.text = user.name
                labelScore.text = NSLocalizedString("Points", comment: "Total number of points") + "\(user.totalPoints())"
                labelTotalGamePlayed.text = NSLocalizedString("GamesPlayed", comment: "Total number of played games") + "\(user.totalGamesPlayes())"
                
                
                if user.id == (NSUserDefaults.standardUserDefaults().objectForKey(userDefaults.LastUser.rawValue) as? String) {
                    backgroundColor = UIColor.mainColor()
                    labelName.textColor = UIColor.whiteColor()
                    labelScore.textColor = UIColor.whiteColor()
                    labelTotalGamePlayed.textColor = UIColor.whiteColor()
                } else {
                    backgroundColor = UIColor.clearColor()
                    labelName.textColor = UIColor.mainColor()
                    labelScore.textColor = UIColor.mainColor()
                    labelTotalGamePlayed.textColor = UIColor.mainColor()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
