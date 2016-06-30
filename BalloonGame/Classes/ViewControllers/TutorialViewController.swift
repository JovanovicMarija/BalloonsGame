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
        
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let frameView = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)

        let sufix = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? "iPad" : ""
        
        //Add panels to an array
        var panels = [MYIntroductionPanel]()
        for i in 0...1 {
            let imageName = "tutorial\(i)"+sufix
            let panel = MYIntroductionPanel(frame: frame, title: NSLocalizedString("Title\(i)", comment: "Title"), description: NSLocalizedString("Description\(i)", comment: "Description"), image: UIImage(named: imageName)!)
            panel.PanelImageView.contentMode = .ScaleAspectFit

            panels.append(panel)
        }
        
        
        //Create the introduction view and set its delegate
        let introductionView = MYBlurIntroductionView(frame: frameView)
        introductionView.delegate = self
        introductionView.backgroundColor = UIColor.mainColor()
        
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
    func introduction(introductionView: MYBlurIntroductionView!, didFinishWithType finishType: MYFinishType) {
        introductionView.BackgroundImageView.image = UIImage(named: "background")
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}