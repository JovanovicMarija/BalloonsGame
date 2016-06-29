//
//  TutorialViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 6/29/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
import MYBlurIntroductionView

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let frame = CGRectMake(0, 64, self.view.frame.width, self.view.frame.height-64)
        let panel1 = MYIntroductionPanel(frame: frame, title: "title", description: "description", image: UIImage(named: "background")!)
        let panel2 = MYIntroductionPanel(frame: frame, title: "title", description: "description", image: UIImage(named: "background")!)
        let panel3 = MYIntroductionPanel(frame: frame, title: "title", description: "description", image: UIImage(named: "background")!)
        
        
        
        //Create the introduction view and set its delegate
        let introductionView = MYBlurIntroductionView(frame: frame)
        introductionView.delegate = self
        introductionView.backgroundColor = UIColor.mainColor()
        
        //Add panels to an array
        let panels = [panel1, panel2, panel3]
        
        //Build the introduction with desired panels
        introductionView.buildIntroductionWithPanels(panels)
        
        //Add the introduction to your view
        self.view.addSubview(introductionView)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TutorialViewController: MYIntroductionDelegate {
    
}