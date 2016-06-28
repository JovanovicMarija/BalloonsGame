//
//  RoundedButton.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/10/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = self.bounds.size.height / 10
    }
}
