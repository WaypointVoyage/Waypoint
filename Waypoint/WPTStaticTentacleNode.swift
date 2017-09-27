//
//  WPTStaticTentacleNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/25/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTStaticTentacleNode: WPTLevelEnemyNode {
    
    private var timer: TimeInterval = 0.0
    private var upTime: TimeInterval = 6.0
    
    init(player: WPTLevelPlayerNode, health: CGFloat) {
        
        super.init(enemy: WPTEnemyCatalog.enemiesByName["Static Tentacle"]!, player: player, startBrain: false, health: WPTShipCatalog.shipsByName["Tentacle"]!.health)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        // make the bubbles
        let emitterNode = SKEmitterNode(fileNamed: "magic.sks")
        self.position = player.position
        emitterNode!.particlePosition = CGPoint(x: self.position.x - self.sprite.size.width, y: self.position.y - self.sprite.size.height)
        emitterNode!.particleSize = CGSize(width: self.sprite.size.width / 5, height: self.sprite.size.height / 5)
        self.addChild(emitterNode!)
        
        // Don't forget to remove the emitter node after the explosion
        self.run(SKAction.wait(forDuration: 6.5), completion: {
        })
        // add to the scene
    }
    
    func submerge() {
        // go back underwater
        // remove from scene
        if let scene = (self.scene as? WPTLevelScene) {
            scene.terrain.removeEnemy(self)
        }
        //need way to store the health to the currTentacle when removing a tentacle from scene
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        super.update(currentTime, deltaTime)
        
        timer += deltaTime
        if timer > upTime {
            submerge()
        }
    }
    
}
