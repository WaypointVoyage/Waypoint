//
//  WPTStorage.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTStorage {
    // TODO: test
    
    let highScorePath: String
    let playerProgressPath: String
    
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        highScorePath = documentsDirectory.appendingPathComponent("high_scores.plist")
        playerProgressPath = documentsDirectory.appendingPathComponent("player_progress.plist")
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
    
    func loadHighScores(count: Int?) -> [WPTLootSummary] {
        if let unarchivedThing = NSKeyedUnarchiver.unarchiveObject(withFile: highScorePath) {
            if let asArray = unarchivedThing as? [WPTLootSummary] {
                return asArray
            }
        }
        return [WPTLootSummary]()
    }
    
    func submitScore(_ score: WPTLootSummary) {
        var scores = self.loadHighScores(count: nil)
        scores.append(score)
        NSKeyedArchiver.archiveRootObject(scores, toFile: highScorePath)
    }
}
