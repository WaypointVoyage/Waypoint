//
//  WPTWhirlpoolHandler.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWhirlpoolHandler: SKNode {
    public static let nodeName: String = "_WHIRLPOOL_HANDLER"
    public static let whirlpoolDamage: CGFloat = -10
    
    private static let spin = SKAction.rotate(byAngle: -.pi * 2, duration: 1.0)
    private static let delay = SKAction.wait(forDuration: 1)
    
    weak var actor: WPTLevelActorNode!
    
    let whirlpoolEffect = WPTAudioNode(effect: "whirlpool")
    
    public private(set) var canEnterWhirlpool = true
    
    init(_ actor: WPTLevelActorNode) {
        self.actor = actor
        super.init()
        self.name = WPTWhirlpoolHandler.nodeName
        
        self.addChild(whirlpoolEffect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enterWhirlpool(damage: CGFloat = WPTWhirlpoolHandler.whirlpoolDamage) {
        self.canEnterWhirlpool = false
        if let scene = self.scene as? WPTLevelScene {
            if scene.getSceneFrame().contains(self.actor.position) {
                self.whirlpoolEffect.playEffect()
            }
        }
        self.actor.run(WPTWhirlpoolHandler.spin)
        self.actor.doDamage(damage)
    }
    
    func exitWhirlpool() {
        self.run(WPTWhirlpoolHandler.delay) {
            self.canEnterWhirlpool = true
        }
    }
}
