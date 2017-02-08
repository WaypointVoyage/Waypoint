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
    
    var path: CGPath?
    let trailShader = SKShader(fileNamed: "trail_shader.fsh")
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func position(for scene: WPTScene) {
        self.removeAllChildren()
        
        let h = scene.frame.width / maxAspectRatio
        let ymin = (scene.frame.height - h) / 2.0;
        self.position = CGPoint(x: 0, y: ymin)
        
        self.path = WPTTrailMapNode.setupTrailMap(size: CGSize(width: scene.frame.width, height: h))
        let trail = SKShapeNode(path: (self.path)!)
        trail.lineWidth = 2.5
        trail.strokeColor = .clear
        trail.strokeShader = trailShader
        
        self.addChild(trail)
    }
    
    static func setupTrailMap(size: CGSize) -> CGPath {
        // TODO: eventually we want to load this from persisted storage.
        let path = UIBezierPath()
        
        path.move(to: WPTTrailMapNode.scaledPoint(x: 0.120790629575, y: 0.831543842525, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.106149341142, y: 0.659102000976, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.146412884334, y: 0.776232308443, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.139092240117, y: 0.71766715471, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.0347730600293, y: 0.398161704897, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.0431918008785, y: 0.56149341142, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.0366032210835, y: 0.495119570522, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.231698389458, y: 0.312266146088, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.0296486090776, y: 0.302505287132, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.0779648609078, y: 0.530909386693, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.149707174231, y: 0.225719863348, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.348096632504, y: 0.145030095982, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.100292825769, y: 0.331787863999, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.334919472914, y: 0.261509679518, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.187408491947, y: 0.0903692858305, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.239751098097, y: 0.0975272490646, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.402635431918, y: 0.429396453555, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.443631039531, y: 0.343500894745, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.451317715959, y: 0.363673336587, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.584919472914, y: 0.515942736294, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.389092240117, y: 0.756059866602, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.534040995608, y: 0.778184480234, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.752562225476, y: 0.640881730926, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.680819912152, y: 0.551732552465, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.830161054173, y: 1.0196030584, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.747437774524, y: 0.54327314137, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.579795021962, y: 0.884252480885, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.643118594436, y: 0.3682284041, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.651903367496, y: 0.312916870018, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.755124450952, y: 0.417683422808, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.724377745242, y: 0.346754514397, size: size))
        path.addCurve(to: WPTTrailMapNode.scaledPoint(x: 0.848462664714, y: 0.210102489019, size: size), controlPoint1: WPTTrailMapNode.scaledPoint(x: 0.569180087848, y: 0.119651862697, size: size), controlPoint2: WPTTrailMapNode.scaledPoint(x: 0.696925329429, y: 0.00122010736945, size: size))
        
        return path.cgPath
    }
    
    static func scaledPoint(x: CGFloat, y: CGFloat, size: CGSize) -> CGPoint {
        return CGPoint(x: x * size.width, y: y * size.height)
    }
}
