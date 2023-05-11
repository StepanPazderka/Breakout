//
//  Ball.swift
//  Breakout iOS
//
//  Created by Štěpán Pazderka on 28.04.2023.
//

import SpriteKit

class Ball: SKShapeNode {
    override init() {
        super.init()

        let sphere = SKShapeNode(ellipseOf: CGSize(width: 30, height: 30))
        sphere.fillColor = .white
//        let path = CGPath(ellipseIn: CGRect(x: -15, y: -15, width: 30, height: 30), transform: nil)
        self.addChild(sphere)
        self.path = path
        self.fillColor = .white
        self.position = CGPoint(x: frame.midX, y: frame.midY)
        self.name = "Ball"
        self.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: self.frame.origin)
        self.physicsBody?.contactTestBitMask = 0x1 << 2
        self.physicsBody?.categoryBitMask = 0x1 << 1
        self.physicsBody?.mass = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
