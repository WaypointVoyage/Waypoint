//
//  WPTTrailMapNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class WPTTrailMapNode: SKNode {
    
    var path: CGPath?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func position(for scene: WPTScene) {
        let h = scene.frame.width / maxAspectRatio
        let ymin = (scene.frame.height - h) / 2.0;
        self.position = CGPoint(x: 0, y: ymin)
//        self.setScale(scene.frame.width)
        
        self.path = WPTTrailMapNode.setupTrailMap(size: scene.frame.size)
        let trail = SKShapeNode(path: (self.path)!)
        trail.fillColor = UIColor.clear
        trail.strokeColor = UIColor.red
        
        self.removeAllChildren()
        self.addChild(trail)
    }
    
    static func setupTrailMap(size: CGSize) -> CGPath {
        // TODO: eventually we want to load this from persisted storage.
        let path = UIBezierPath()
        path.move(to: WPTTrailMapNode.scaledPoint(x: 0.11420204978, y: 0.827160493827, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.106881405564, y: 0.66081871345, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.0344070278184, y: 0.396361273554, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.231698389458, y: 0.311241065627, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.149707174231, y: 0.224171539961, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.336383601757, y: 0.259909031839, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.403733528551, y: 0.425601039636, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.584553440703, y: 0.51656920078, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.752928257687, y: 0.640675763483, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.748169838946, y: 0.543209876543, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.652269399707, y: 0.309291747888, size: size))
        path.addLine(to: WPTTrailMapNode.scaledPoint(x: 0.850292825769, y: 0.212475633528, size: size))
        return path.cgPath
    }
    
    static func scaledPoint(x: CGFloat, y: CGFloat, size: CGSize) -> CGPoint {
        return CGPoint(x: x * size.width, y: y * size.height)
    }
}
