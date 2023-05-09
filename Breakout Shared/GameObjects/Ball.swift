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
        self.fillColor = .white
        self.position = CGPoint(x: frame.midX, y: frame.midY)
        self.name = "Ball"
        self.setupPhysicalBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysicalBody() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        self.physicsBody?.contactTestBitMask = 0x1 << 2
        self.physicsBody?.categoryBitMask = 0x1 << 1
        self.physicsBody?.mass = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
    }
}
