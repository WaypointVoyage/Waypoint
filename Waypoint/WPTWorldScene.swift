//
//  WPTWorldScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import UIKit

class WPTWorldScene: WPTScene {
    
    let worldMap = WPTWorldMapNode()
    let trailMap: WPTTrailMapNode
    let player: WPTWorldPlayerNode
    
    private var currentStop: Int = -1
    
    init(player: WPTPlayer) {
        self.trailMap = WPTTrailMapNode(progress: player.progress)
        self.player = WPTWorldPlayerNode(player)
        super.init(size: CGSize(width: 0, height: 0))
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        worldMap.position(for: self)
        self.addChild(worldMap)
        
        trailMap.zPosition = 1
        trailMap.position(for: self)
        self.addChild(trailMap)
        
        self.player.position = self.trailMap.trailMap!.startLocation
        self.currentStop = 0
        self.player.zPosition = 10
        self.addChild(self.player)
        
        let back = WPTHomeScene.getBack(frame: self.frame)
        back.color = .black
        back.text = "Exit"
        self.addChild(back)
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.player.update(currentTime)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if let target = self.trailMap.getStopIndex(for: touch) {
            if let path = self.trailMap.getConnectedPath(from: self.currentStop, to: target) {
                print("found path!")
                print(path)
            }
        }
    }
}
