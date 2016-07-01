//
//  AddChildCollectionViewCell.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/19/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit

class AddChildCollectionViewCell: UICollectionViewCell {
    
    var letter: String! {
        didSet {
            labelLetter.text = self.letter
            labelLetter.textColor = UIColor.whiteColor()
        }
    }
    
    @IBOutlet weak var labelLetter: UILabel!
    
}
