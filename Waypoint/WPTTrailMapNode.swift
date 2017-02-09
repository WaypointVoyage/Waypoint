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
    
    var trailMap: WPTTrailMap?
    let trailShader = SKShader(fileNamed: "trail_shader.fsh")
    
    let unlockedMarkerTexture = SKTexture(imageNamed: "blue_circle")
    let lockedMarkerTexture = SKTexture(imageNamed: "red_circle")
    let treasureMarkerTexture = SKTexture(imageNamed: "x_marks_the_spot")
    
    func position(for scene: WPTScene) {
        self.removeAllChildren()
        
        let h = scene.frame.width / maxAspectRatio
        let ymin = (scene.frame.height - h) / 2.0;
        self.position = CGPoint(x: 0, y: ymin)
        
        self.trailMap = WPTTrailMap(mapSize: CGSize(width: scene.frame.width, height: h))
        let trail = SKShapeNode(path: self.trailMap!.toCGPath())
        trail.lineWidth = 2.5
        trail.strokeColor = .clear
        trail.strokeShader = trailShader
        
        self.addChild(trail)
        
        self.trailMap!.traversePoints({
            (index, point, isUnlocked) in
            
            var texture = isUnlocked ? unlockedMarkerTexture : lockedMarkerTexture
            
            var scale: CGSize?
            switch (index) {
            case 0:
                scale = CGSize(width: 30, height: 30)
            case self.trailMap!.stopCount - 1:
                scale = CGSize(width: 45, height: 45)
                texture = treasureMarkerTexture
            default:
                scale = CGSize(width: 20, height: 20)
            }
            
            let marker = SKSpriteNode(texture: texture)
            marker.position = point
            marker.scale(to: scale!)
            marker.zPosition = 2
            self.addChild(marker)
        })
    }
}
