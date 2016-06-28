//
//  DailyStatisticsTableViewCell.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 6/23/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit

class DailyStatisticsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewGameMode: UIImageView! {
        didSet {
            imageViewGameMode.contentMode = .ScaleAspectFit
        }
    }
    
    @IBOutlet weak var labelStartingTime: UILabel!
    
    @IBOutlet weak var labelDuration: UILabel!
    
    @IBOutlet weak var labelPoints: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
