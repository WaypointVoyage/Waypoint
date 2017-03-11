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
    
    let levelName = WPTLabelNode(text: "Level", fontSize: WPTValues.fontSizeMedium)
    let startLevel = WPTLabelNode(text: "Start", fontSize: WPTValues.fontSizeMedium)
    
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
        
        self.levelName.position = CGPoint(x: self.frame.midX, y: 0.85 * self.frame.height)
        self.levelName.zPosition = 5
        self.levelName.fontColor = .black
        self.addChild(self.levelName)
        
        trailMap.zPosition = 1
        trailMap.position(for: self)
        self.addChild(trailMap)
        
        self.player.position = self.trailMap.trailMap!.startLocation
        self.player.zPosition = 10
        self.updatePlayerStopLocation(0)
        self.addChild(self.player)
        
        let back = WPTHomeScene.getBack(frame: self.frame)
        back.position.x = 0.4 * self.frame.width
        back.fontColor = UIColor.black
        back.text = "Exit"
        self.addChild(back)
    
        self.startLevel.verticalAlignmentMode = .top
        self.startLevel.fontColor = UIColor.black
        self.startLevel.position = CGPoint(x: 0.6 * self.frame.width, y: back.position.y)
        self.addChild(self.startLevel)
    }
    
    private var lastCurrentTime: TimeInterval? = nil
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = lastCurrentTime == nil ? 0 : currentTime - lastCurrentTime!
        self.lastCurrentTime = currentTime
        self.player.update(currentTime, deltaTime)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        // start level
        if self.startLevel.contains(touch.location(in: self)) && self.startLevel.alpha == 1.0 {
            let level = self.trailMap.trailMap![self.currentStop].level!
            let levelScene = WPTLevelScene(player: self.player.player, level: level)
            self.scene?.view?.presentScene(levelScene)
        }
        
        // movement along the trail
        else if !self.player.hasActions() {
            if let target = self.trailMap.getStopIndex(for: touch) {
                if let path = self.trailMap.getConnectedPath(from: self.currentStop, to: target) {
                    
                    self.levelName.isHidden = true
                    self.startLevel.alpha = 0.4
                    let speed = !WPTConfig.values.testing ? WPTWorldPlayerNode.pathSpeed : 10 * WPTWorldPlayerNode.pathSpeed
                    let action = SKAction.follow(path, asOffset: false, orientToPath: false, speed: speed)
                    self.player.run(action, completion: {
                        self.levelName.isHidden = false
                        self.startLevel.alpha = 1.0
                        self.updatePlayerStopLocation(target)
                    })
                }
            }
        }
    }
    
    func updatePlayerStopLocation(_ stopIndex: Int) {
        self.currentStop = stopIndex
        let stop = self.trailMap.trailMap![stopIndex]
        
        // TODO: actions to update the UI to start a specific level
        self.levelName.text = stop.level?.name
    }
}
