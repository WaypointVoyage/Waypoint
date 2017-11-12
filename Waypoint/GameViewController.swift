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
            let storage = WPTStorage()
            if let loadedThing = storage.loadGlobalSettings() {
                WPTAudioConfig.setInstance(loadedThing)
            }
            
            view.presentScene(getSceneToLoad())
            
            // set up the view
            view.ignoresSiblingOrder = true
            
            if WPTConfig.values.testing {
                view.showsFPS = true
                view.showsNodeCount = true
            }
            if WPTConfig.values.showPhysics {
                view.showsPhysics = true
            }
            
            if WPTConfig.values.clearHighScoresOnLoad {
                storage.deleteHighScores()
            }
            if WPTConfig.values.clearPlayerProgress {
                storage.clearPlayerProgress()
            }
            if WPTConfig.values.clearGlobalSettings {
                storage.clearGlobalSettings()
            }
            
        }
    }
    
    func getSceneToLoad() -> SKScene {
        switch (WPTConfig.values.mode) {
            
        case WPTAppMode.NORMAL:
            return WPTSplashScene()
            
        case WPTAppMode.LEVEL:
            let level = WPTLevel(WPTLevelModeConfig.values.levelFileName)
            NSLog("Starting level \(level.name)")
            
            let progress = getPreconfiguredPlayerProgress()
            if let itemCount = WPTConfig.values.giveRandomItems {
                
                NSLog("Giving player \(itemCount) items")
                progress.items.removeAll()
                for item in WPTItemCatalog.getRandomItems(count: itemCount) {
                    NSLog("  - \(item.name)")
                    progress.items.append(item.name)
                }
                
                let cannonCount = Int(itemCount / WPTConfig.values.itemsPerCannon!)
                NSLog("Giving player \(cannonCount) cannons")
                for _ in 0..<cannonCount {
                    progress.items.append("Cannon")
                }
            }
            let player = WPTPlayer(playerProgress: progress)
            let ship = player.ship
            NSLog("  speed     : \(ship.speedScale)")
            NSLog("  damage    : \(ship.damageScale)")
            NSLog("  health    : \(ship.healthScale)")
            NSLog("  range     : \(ship.rangeScale)")
            NSLog("  shotSpeed : \(ship.shotSpeedScale)")
            NSLog("  size      : \(ship.sizeScale)")
            NSLog("  turnRate  : \(ship.turnRateScale)")
            NSLog("  fireRate  : \(ship.fireRateScale)")
            NSLog("  itemRadius: \(ship.itemRadiusScale)")
            
            return WPTLevelScene(player: player, level: level)
            
        case WPTAppMode.WORLDMAP:
            NSLog("Starting on world map")
            let player = WPTPlayer(playerProgress: getPreconfiguredPlayerProgress())
            return WPTWorldScene(player: player)
            
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
