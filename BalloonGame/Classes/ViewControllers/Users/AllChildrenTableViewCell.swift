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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
