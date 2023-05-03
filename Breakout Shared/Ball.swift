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

        let path = CGPath(ellipseIn: CGRect(x: -20, y: -20, width: 40, height: 40), transform: nil)
        self.path = path
        self.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.mass = 0.0
        self.name = "Ball"
        self.physicsBody?.contactTestBitMask = 0x1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
