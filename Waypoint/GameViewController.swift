//
//  GameViewController.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WPTValues.initValues(deviceScreenSize: self.view.frame.size)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = WPTSplashScene()
            view.presentScene(scene)
            
            // set up the view
            view.ignoresSiblingOrder = true
            
            if WPTConfig.values.testing {
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
