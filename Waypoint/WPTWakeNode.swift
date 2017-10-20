//
//  WPTWakeNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/12/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWakeNode: SKNode, WPTUpdatable {
    private static let WAKE_FRAME_COUNT: Int = 24
    private static let WAKE_FRAME_TIME_DELTA: TimeInterval = 0.05
    
    public weak var actor: WPTLevelActorNode?
    private var frames = [WPTWakeFrame]()
    private var framesPath: [CGPoint] = [CGPoint]()
    public var done: Bool {
        return frames.isEmpty
    }
    
    private var shapeNode: SKShapeNode! = nil
    
    init(_ actor: WPTLevelActorNode) {
        self.actor = actor
        super.init()
        self.zPosition = 1 // just above the terrain
        
        let firstFrame = WPTWakeFrame(self.actor!)
        self.frames.append(firstFrame)
        self.framesPath = [firstFrame.starboardPoint, firstFrame.portPoint]
        
        self.shapeNode = SKShapeNode.init(splinePoints: &framesPath, count: framesPath.count)
        self.shapeNode.lineWidth = 8
        self.shapeNode.strokeShader = SKShader(fileNamed: "wake_edge.fsh")
        self.shapeNode.fillShader = SKShader(fileNamed: "wake_fill.fsh")
        self.shapeNode.fillShader!.addUniform(SKUniform(name: "u_actor_dir_x", float: 0.0))
        self.shapeNode.fillShader!.addUniform(SKUniform(name: "u_actor_dir_y", float: 1.0))
        self.addChild(shapeNode)
    }
    
    private func actorAlive() -> Bool {
        if let actor = self.actor {
            if actor.isPlayer && WPTConfig.values.invincible {
                return true
            }
            return actor.currentHealth > 0
        }
        return false
    }
    
    private var frameCounter: TimeInterval = 0.0
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        if self.actorAlive() {
            // update the direction
            let forward = self.actor!.forward
            self.shapeNode.fillShader!.uniformNamed("u_actor_dir_x")!.floatValue = Float(forward.dx)
            self.shapeNode.fillShader!.uniformNamed("u_actor_dir_y")!.floatValue = Float(forward.dy)
        }

        // check if we need to shift the points
        self.frameCounter += deltaTime
        if self.frameCounter > WPTWakeNode.WAKE_FRAME_TIME_DELTA {
            self.frameCounter = 0.0

            if self.actorAlive() {
                // add the new frame/points
                let newFrame = WPTWakeFrame(actor!)
                self.frames.append(newFrame)
                let middle = self.framesPath.count / 2
                self.framesPath.insert(newFrame.portPoint, at: middle)
                self.framesPath.insert(newFrame.starboardPoint, at: middle)
            }

            if self.frames.count > WPTWakeNode.WAKE_FRAME_COUNT || !self.actorAlive() {
                // remove the oldest frame/points
                self.frames.removeFirst()
                self.framesPath.removeFirst()
                self.framesPath.removeLast()
            }
        }
        
        for frame in self.frames {
            frame.update(currentTime, deltaTime)
        }
        self.updateFramesPath()
        self.shapeNode.path = CGPath.fromPoints(self.framesPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateFramesPath() {
        for i in 0..<self.frames.count {
            let frame = self.frames[i]
            
            let portIndex = i
            let starboardIndex = self.framesPath.count - i - 1
            
            self.framesPath[portIndex] = frame.portPoint
            self.framesPath[starboardIndex] = frame.starboardPoint
        }
    }
    
    /////////////
    
    private static func getActorWakeFactor(_ actor: WPTLevelActorNode) -> CGFloat {
        let ship = actor.actor.ship
        let sizeFraction: CGFloat = (ship.size - WPTShip.minSize) / (WPTShip.maxSize - WPTShip.minSize)
        let curSpeedFraction: CGFloat = atan(0.0005 * (actor.physicsBody?.velocity.magnitude() ?? 0.0)) / CGFloat(.pi / 2.0)
        var result: CGFloat = pow(sizeFraction, 4.0) * curSpeedFraction
        clamp(&result, min: 0.0, max: 1.0)
        return result
    }
    
    private class WPTWakeFrame: WPTUpdatable {
        static let MAX_WAKE_SPEED: CGFloat = 80
        
        public private(set) var portPoint: CGPoint
        public private(set) var starboardPoint: CGPoint
        private let portDir: CGVector
        private let starboardDir: CGVector
        
        private let factor: CGFloat
        
        init(_ actor: WPTLevelActorNode) {
            self.factor = WPTWakeNode.getActorWakeFactor(actor)
            let lengthOffset = actor.xScale * actor.sprite.frame.width / 2.5 // might need to set these values individually for each ship
            let widthOffset = actor.yScale * actor.sprite.frame.height / 7.2
            let motorPos = actor.position - (lengthOffset * actor.forward)
            self.portDir = actor.portSide
            self.starboardDir = actor.starboardSide
            self.portPoint = motorPos + widthOffset * self.portDir
            self.starboardPoint = motorPos + widthOffset * self.starboardDir
        }
        
        func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
            self.portPoint += factor * WPTWakeFrame.MAX_WAKE_SPEED * self.portDir
            self.starboardPoint += factor * WPTWakeFrame.MAX_WAKE_SPEED * self.starboardDir
        }

    }
}
