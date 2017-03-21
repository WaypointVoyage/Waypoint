//
//  WPTStorage.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTStorage {
    
    let highScorePath: URL
    
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        highScorePath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("high_scores.plist")!
        print("highScorePath: \(highScorePath)")
    }
    
    func savePlayerProgress(_ progress: WPTPlayerProgress) {
        // TODO: implement
    }
    
    func clearPlayerProgress() {
        // TODO: implement
    }
    
    func loadPlayerProgress() -> WPTPlayerProgress? {
        // TODO: implement
        return nil
    }
    
    func loadHighScores(count: Int?) -> [WPTLootSummary] {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: highScorePath.absoluteString) as? [WPTLootSummary]) ?? [WPTLootSummary]()
    }
    
    func submitScore(_ score: WPTLootSummary) {
        var scores = self.loadHighScores(count: nil)
        scores.append(score)
        NSKeyedArchiver.archiveRootObject(scores, toFile: highScorePath.absoluteString)
    }
}
