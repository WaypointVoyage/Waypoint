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
    let globalSettingsPath: String
    
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        highScorePath = documentsDirectory.appendingPathComponent("high_scores.plist")
        playerProgressPath = documentsDirectory.appendingPathComponent("player_progress.plist")
        globalSettingsPath = documentsDirectory.appendingPathComponent("global_settings.plist")
    }
    
    func deleteHighScores() {
        NSLog("deleting high scores...")
        do {
            try FileManager.default.removeItem(atPath: highScorePath)
        } catch let error as NSError {
            NSLog("WARN: Could not delete high scores")
            NSLog(error.debugDescription)
        }
    }
    
    func seedHighScores() {
        deleteHighScores()
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
    
    func deletePlayerProgress() {
        NSLog("deleting player progress...")
        do {
            try FileManager.default.removeItem(atPath: playerProgressPath)
        } catch let error as NSError {
            NSLog("WARN: Could not delete player progress")
            NSLog(error.debugDescription)
        }
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
    
    func saveGlobalSettings() {
        NSLog("Saving global settings")
        NSKeyedArchiver.archiveRootObject(WPTAudioConfig.audio, toFile: self.globalSettingsPath)
    }
    
    func loadGlobalSettings() -> WPTAudioConfig? {
        NSLog("Loading global settings")
        if let unarchivedThing = NSKeyedUnarchiver.unarchiveObject(withFile: globalSettingsPath) {
            if let asGlobalSettings = unarchivedThing as? WPTAudioConfig {
                return asGlobalSettings
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
        if scores.count <= WPTValues.maxHighScores || score.doubloons > scores.last!.doubloons {
            scores.append(score)
            scores.sort()
            let extra = scores.count - WPTValues.maxHighScores
            if extra > 0 {
                scores.removeLast(extra)
            }
            NSKeyedArchiver.archiveRootObject(scores, toFile: highScorePath)
        }
    }
}
