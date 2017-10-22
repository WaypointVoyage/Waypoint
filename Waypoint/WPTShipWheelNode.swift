//
//  WPTShipWheelNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTShipWheelNode: SKNode, WPTUpdatable {
   
    private let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "steering_wheel")
    
    private weak var touch: UITouch? = nil
    var moveTouchDist: CGFloat? {
        if let target = self.touch?.location(in: self) {
            let mag = CGVector(start: CGPoint.zero, end: target).magnitude()
            var fraction = mag / (0.8 * self.radius)
            clamp(&fraction, min: 0.0, max: 1.0)
            return fraction
        }
        return nil
    }
    
    private let radius: CGFloat
    
    override init() {
        self.radius = self.sprite.size.width / 2.0
        super.init()
        self.zPosition = WPTZPositions.touchHandler + 2 - WPTZPositions.hud
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getTouch() -> UITouch? {
        return self.touch
    }
    
    public func setTouch(_ touch: UITouch?) {
        self.touch = touch
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        guard let player = (self.scene as? WPTLevelScene)?.player, let touch = self.touch else { return }
        let touchLoc = touch.location(in: self)
        let touchVec = CGVector(dx: touchLoc.x, dy: touchLoc.y)
        player.facePoint(player.position + touchVec)
        let angle = touchVec.angle()
        self.sprite.zRotation = angle
    }
    
}
