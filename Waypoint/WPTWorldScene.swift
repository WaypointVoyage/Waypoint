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
    
    let startLevel = WPTLabelNode(text: "Level", fontSize: WPTValues.fontSizeMedium)
    
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
        
        self.startLevel.position = CGPoint(x: self.frame.midX, y: 0.75 * self.frame.height)
        self.startLevel.zPosition = 5
        self.startLevel.fontColor = .black
        self.addChild(startLevel)
        
        trailMap.zPosition = 1
        trailMap.position(for: self)
        self.addChild(trailMap)
        
        self.player.position = self.trailMap.trailMap!.startLocation
        self.player.zPosition = 10
        self.updatePlayerStopLocation(0)
        self.addChild(self.player)
        
        let back = WPTHomeScene.getBack(frame: self.frame)
        back.position.x = self.frame.midX
        back.fontColor = .black
        back.text = "Exit"
        self.addChild(back)
        
        /* TEST LEVEL LABEL */
        let level = WPTLevel("file name", beaten: false)
        let testLevelLabel = WPTSceneLabelNode(text: "test level", next: WPTLevelScene(player: self.player.player, level: level))
        testLevelLabel.zPosition = 5
        testLevelLabel.position = CGPoint(x: 0.8 * self.frame.width, y: 0.1 * self.frame.height)
        self.addChild(testLevelLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.player.update(currentTime)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if !self.player.hasActions() {
            if let target = self.trailMap.getStopIndex(for: touch) {
                if let path = self.trailMap.getConnectedPath(from: self.currentStop, to: target) {
                    
                    self.startLevel.isHidden = true
                    let action = SKAction.follow(path, asOffset: false, orientToPath: false, speed: WPTWorldPlayerNode.pathSpeed)
                    self.player.run(action, completion: {
                        self.startLevel.isHidden = false
                        self.updatePlayerStopLocation(target)
                    })
                }
            }
        }
    }
    
    private func updatePlayerStopLocation(_ stopIndex: Int) {
        self.currentStop = stopIndex
        let stop = self.trailMap.trailMap![stopIndex]
        
        // TODO: actions to update the UI to start a specific level
        self.startLevel.text = stop.level.name
    }
}
