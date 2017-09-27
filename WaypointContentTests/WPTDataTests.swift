//
//  WPTDataTests.swift
//  WaypointContentTests
//
//  Created by Cameron Taylor on 9/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import XCTest
@testable import Waypoint

class WPTDataTests: XCTestCase {
    
    /*
    Tests for Waypoint's Data files (plists)
    All of the plist files are verified here,
    with the exception of the files that are
    served by a corresponding WPTCatalog
    */
    
    // random_ship_names.plist should be an array of strings,
    // none of which should be longer than WPTShip.MAX_SHIP_NAME_LENGTH
    func testRandomShipNamesPlist() {
        // should be an array of strings, none of which are longer than the max length
        let namesPlist = Bundle.main.path(forResource: "random_ship_names", ofType: "plist")!
        let names = NSArray(contentsOfFile: namesPlist) as! [String]
        
        for name in names {
            XCTAssertLessThanOrEqual(name.count, WPTShip.MAX_SHIP_NAME_LENGTH,
                                     "Ship name \(name) is too long (\(name.count) characters)")
        }
    }
    
    func testLevelPlists() {
        let trailMapPlist = Bundle.main.path(forResource: "trail_map", ofType:"plist")!
        let trailMap = NSDictionary(contentsOfFile: trailMapPlist) as! [String:Any]
        
        // get the names of the levels
        var levels = [String]()
        levels.append((trailMap["startPoint"] as! [String:Any])["levelNamed"] as! String)
        let points = trailMap["points"] as! [[String:Any]]
        for point in points {
            levels.append(point["levelNamed"] as! String)
        }
        
        // iterate though the levels
        for name in levels {
            let level = WPTLevel(name)
            
            // name
            XCTAssertGreaterThan(level.name.count, 0, "Level \(name) has no name")
            
            // spawn point
            verifyPointInLevel(name, "spawnPoint", point: level.spawnPoint, levelSize: level.size)
            
            // port
            if let port = level.port {
                verifyPointInLevel(name, "port.position", point: port.position, levelSize: level.size)
            }
            
            // terrain
            for i in 0..<level.terrainBodies!.count {
                let terrain = level.terrainBodies![i]
                for j in 0..<terrain.count {
                    let point = terrain[j]
                    let coord = CGPoint(x: point[0], y: point[1])
                    verifyPointInLevel(name, "'terrain body \(i), point \(j)'", point: coord, levelSize: level.size)
                }
            }
            XCTAssertNotNil(level.terrainImage)
            XCTAssertNotNil(UIImage(named: level.terrainImage!))
            XCTAssertNotNil(level.waterImage)
            XCTAssertNotNil(UIImage(named: level.waterImage!))
            
            // we know enemies in the waves are valid since they are loaded as part of the level initialization process
        }
    }
    
    func verifyPointInLevel(_ level: String, _ name: String, point: CGPoint, levelSize: CGSize) {
        XCTAssertTrue(0 <= point.x && point.x <= levelSize.width,
                      "Level \(level) has a point \"\(name)\" with a bad x coord. \(point.x) is not in the range [0, \(levelSize.width)]")
        XCTAssertTrue(0 <= point.y && point.y <= levelSize.height,
                      "Level \(level) has a point \"\(name)\" with a bad y coord. \(point.y) is not in the range [0, \(levelSize.height)]")
    }
    
    // The trail map is described by a set of points and control points.
    // this makes sure that the trail stays within the map bounds
    func testTrailMapPlist() {
        let trailMapPlist = Bundle.main.path(forResource: "trail_map", ofType: "plist")!
        let trailMap = NSDictionary(contentsOfFile: trailMapPlist) as! [String:Any]
        
        // check the start point
        let startPoint = trailMap["startPoint"] as! [String:Any]
        let startPointTarget = startPoint["target"] as! [String:CGFloat]
        var point = CGPoint(x: startPointTarget["x"]!, y: startPointTarget["y"]!)
        verifyPoint("startPoint - target", point)
        
        // check the other points
        let points = trailMap["points"] as! [[String:Any]]
        for i in 0..<points.count {
            let pointDict = points[i]
            
            let target = pointDict["target"] as! [String:CGFloat]
            point = CGPoint(x: target["x"]!, y: target["y"]!)
            verifyPoint("point\(i) - target", point)
            
            let controlPoint1 = pointDict["controlPoint1"] as! [String:CGFloat]
            point = CGPoint(x: controlPoint1["x"]!, y: controlPoint1["y"]!)
            verifyPoint("point\(i) - controlPoint1", point)
            
            let controlPoint2 = pointDict["controlPoint2"] as! [String:CGFloat]
            point = CGPoint(x: controlPoint2["x"]!, y: controlPoint2["y"]!)
            verifyPoint("point\(i) - controlPoint2", point)
        }
        
    }
    
    private func verifyPoint(_ name: String, _ point: CGPoint) {
        XCTAssertTrue(0 <= point.x && point.x <= 1, "(\(name))'s x coordinate (\(point.x) is not in the range [0, 1]")
        XCTAssertTrue(0 <= point.y && point.y <= 1, "(\(name))'s y coordinate (\(point.y) is not in the range [0, 1]")
    }
    
}
