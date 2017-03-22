//
//  WPTStorage.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTStorage {
    
    let highScorePath: String
    let playerProgressPath: String
    
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        highScorePath = documentsDirectory.appendingPathComponent("high_scores.plist")
        playerProgressPath = documentsDirectory.appendingPathComponent("player_progress.plist")
    }
    
    func seedHighScores() {
        do {
            try FileManager.default.removeItem(atPath: highScorePath)
        } catch let error as NSError {
            NSLog("WARN: Could not delete high scores")
            NSLog(error.debugDescription)
        }
        
        for i in 0..<WPTValues.maxHighScores {
            let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let ship = WPTShipCatalog.playableShips[Int(rand * CGFloat(WPTShipCatalog.playableShips.count))]
            let loot = WPTLootSummary(shipName: ship.name, doubloons: 500 - 5 * i, date: Date(), items: [])
            self.submitScore(loot)
        }
    }
    
    func savePlayerProgress(_ progress: WPTPlayerProgress) {
        NSLog("Saving PlayerProgress")
        NSKeyedArchiver.archiveRootObject(progress, toFile: self.playerProgressPath)
    }
    
    func clearPlayerProgress() {
        NSLog("Clearing Player Progress")
        do {
            try FileManager.default.removeItem(atPath: playerProgressPath)
        } catch let error as NSError {
            NSLog("WARN: Could not delete player progress")
            NSLog(error.debugDescription)
        }
    }
    
    func loadPlayerProgress() -> WPTPlayerProgress? {
        NSLog("Loading Player Progress")
        if let unarchivedThing = NSKeyedUnarchiver.unarchiveObject(withFile: playerProgressPath) {
            if let asPlayerProgress = unarchivedThing as? WPTPlayerProgress {
                return asPlayerProgress
            }
        }
        return nil
    }
    
    func loadHighScores() -> [WPTLootSummary] {
        if let unarchivedThing = NSKeyedUnarchiver.unarchiveObject(withFile: highScorePath) {
            if let asArray = unarchivedThing as? [WPTLootSummary] {
                return asArray.sorted()
            }
        }
        return [WPTLootSummary]()
    }
    
    func submitScore(_ score: WPTLootSummary) {
        var scores = self.loadHighScores()
        if scores.count <= 0 || score > scores.last! {
            scores.append(score)
            let extra = scores.count - WPTValues.maxHighScores
            if extra > 0 {
                scores.removeLast(extra)
            }
            NSKeyedArchiver.archiveRootObject(scores, toFile: highScorePath)
        }
    }
}
