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
    private static let version = "1.1"
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    let highScorePath: String
    let playerProgressPath: String
    let globalSettingsPath: String
    
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        highScorePath = documentsDirectory.appendingPathComponent("high_scores.\(WPTStorage.version).json")
        playerProgressPath = documentsDirectory.appendingPathComponent("player_progress.\(WPTStorage.version).json")
        globalSettingsPath = documentsDirectory.appendingPathComponent("global_settings.\(WPTStorage.version).json")
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
        do {
            let data = try jsonEncoder.encode(progress)
            try data.write(to: URL(fileURLWithPath: playerProgressPath))
        } catch let error {
            NSLog("ERROR: WPTStorage failed to save player progress: \(String(describing: error))")
        }
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
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: playerProgressPath))
            let asPlayerProgress = try jsonDecoder.decode(WPTPlayerProgress.self, from: data)
            return asPlayerProgress
        } catch let error {
            NSLog("ERROR: WPTStorage failed to load player progress: \(String(describing: error))")
        }
        return nil
    }
    
    func saveGlobalSettings() {
        NSLog("Saving global settings")
        do {
            let data = try jsonEncoder.encode(WPTAudioConfig.audio)
            try data.write(to: URL(fileURLWithPath: globalSettingsPath))
        } catch let error {
            NSLog("ERROR: WPTStorage failed to save global settings: \(String(describing: error))")
        }
    }
    
    func loadGlobalSettings() -> WPTAudioConfig? {
        NSLog("Loading global settings")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: globalSettingsPath))
            let asGlobalSettings = try jsonDecoder.decode(WPTAudioConfig.self, from: data)
            return asGlobalSettings
        } catch let error {
            NSLog("ERROR: WPTStorage failed to load global settings: \(String(describing: error))")
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
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: highScorePath))
            let asArray = try jsonDecoder.decode([WPTLootSummary].self, from: data)
            return asArray.sorted()
        } catch let error {
            NSLog("ERROR: WPTStorage failed to load high scores: \(String(describing: error))")
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

            do {
                let data = try jsonEncoder.encode(scores)
                try data.write(to: URL(fileURLWithPath: highScorePath))
            } catch let error {
                NSLog("ERROR: WPTStorage failed to submit score: \(String(describing: error))")
            }
        }
    }
}
