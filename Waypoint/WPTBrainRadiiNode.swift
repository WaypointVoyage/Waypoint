//
//  WPTBrainRadiiNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/11/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTBrainRadiiNode: SKNode, WPTUpdatable {
    let brain: WPTBrain
    
    private let engagement: SKShapeNode
    private let innerOblivious: SKShapeNode
    private let outerOblivious: SKShapeNode
    private let safety: SKShapeNode
    
    init(brain: WPTBrain) {
        self.brain = brain
        engagement = SKShapeNode(circleOfRadius: brain.radiusOfEngagement)
        innerOblivious = SKShapeNode(circleOfRadius: brain.innerRadiusOfObliviousness)
        outerOblivious = SKShapeNode(circleOfRadius: brain.outerRadiusOfObliviousness)
        safety = SKShapeNode(circleOfRadius: brain.radiusOfSafety)
        super.init()
        
        setRadii()
        safety.strokeColor = UIColor.green
        outerOblivious.strokeColor = UIColor.yellow
        innerOblivious.strokeColor = UIColor.orange
        engagement.strokeColor = UIColor.red
        for radius in [engagement, innerOblivious, outerOblivious, safety] {
            radius.lineWidth = 2
            self.addChild(radius)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setRadii() {
        // TODO: update radii if changed
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        setRadii()
    }
}
