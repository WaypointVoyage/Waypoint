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
        self.archiveObject(data: progress, path: self.playerProgressPath)
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
        if let asPlayerProgress : WPTPlayerProgress = self.unarchiveObject(path: playerProgressPath) {
            return asPlayerProgress
        }
        return nil
    }
    
    func saveGlobalSettings() {
        NSLog("Saving global settings")
        self.archiveObject(data: WPTAudioConfig.audio, path: self.globalSettingsPath)
    }
    
    func loadGlobalSettings() -> WPTAudioConfig? {
        NSLog("Loading global settings")
        if let asGlobalSettings : WPTAudioConfig = self.unarchiveObject(path: globalSettingsPath) {
            return asGlobalSettings
        }
        return nil
    }
    
    func clearGlobalSettings() {
        NSLog("Clearing Global Settings")
        do {
            try FileManager.default.removeItem(atPath: globalSettingsPath)
        } catch let error as NSError {
            NSLog("WARN: Could not delete global settings")
            NSLog(error.debugDescription)
        }
    }
    
    func loadHighScores() -> [WPTLootSummary] {
        if let asArray: [WPTLootSummary] = self.unarchiveArray(path: highScorePath) {
            return asArray.sorted()
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
            self.archiveObject(data: scores, path: highScorePath)
        }
    }

    private func archiveObject(data: Any, path: String) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            try data.write(to: URL(fileURLWithPath: path))
        } catch let error {
            NSLog("Error: WPTStorage failed to archive object: \(error.localizedDescription)")
        }
    }

    private func unarchiveObject<T: NSObject & NSCoding>(path: String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
            return result
        } catch let error {
            NSLog("Error: WPTStorage failed to unarchive object: \(error.localizedDescription)")
            return nil
        }
    }

    private func unarchiveArray<T: NSObject & NSSecureCoding>(path: String) -> [T]? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: T.self, from: data)
            return result
        } catch let error {
            NSLog("Error: WPTStorage failed to unarchive object: \(error.localizedDescription)")
            return nil
        }
    }
}
