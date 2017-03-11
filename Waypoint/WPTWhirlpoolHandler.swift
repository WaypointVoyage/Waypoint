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
    public static let whirlpoolDamage: CGFloat = -5
    
    private static let spin = SKAction.rotate(byAngle: -.pi * 2, duration: 1.0)
    private static let delay = SKAction.wait(forDuration: 1)
    
    weak var actor: WPTLevelActorNode!
    
    public private(set) var canEnterWhirlpool = true
    
    init(_ actor: WPTLevelActorNode) {
        self.actor = actor
        super.init()
        self.name = WPTWhirlpoolHandler.nodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enterWhirlpool() {
        self.canEnterWhirlpool = false
        self.actor.run(WPTWhirlpoolHandler.spin)
        if let hud = (self.scene as? WPTLevelScene)?.hud {
            let oldHealth = actor.currentHealth
            actor.currentHealth -= WPTWhirlpoolHandler.whirlpoolDamage
            hud.processShipHealthStatus(actor.currentHealth - oldHealth)
        }
    }
    
    func exitWhirlpool() {
        self.run(WPTWhirlpoolHandler.delay) {
            self.canEnterWhirlpool = true
        }
    }
}
