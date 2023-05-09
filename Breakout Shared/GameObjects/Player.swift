//
//  Player.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 04.05.2023.
//

import SpriteKit

class Player: SKNode {
    let size = CGSize(width: 200, height: 20)
    
    override init() {
        super.init()
        
        let shape = SKShapeNode(rectOf: size, cornerRadius: 10)
        shape.fillColor = .red
        shape.lineWidth = 0.0
        self.addChild(shape)
        self.name = "Player"
        self.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.collisionBitMask = 0x1 << 1
        self.physicsBody?.categoryBitMask = 0x1 << 1
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
    }
    
    func setupPhysicalBody() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
