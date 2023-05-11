//
//  Block.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 29.04.2023.
//

import SpriteKit
#if os(OSX)
import AppKit
#endif
#if os(iOS) || os(tvOS)
import UIKit
#endif

class Block: SKNode {
    
    init(size: CGSize) {
        super.init()
        
        //        self.path = CGPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: nil)
        let cube = SKShapeNode(rectOf: size)
        cube.fillColor = .red
        self.calculateAccumulatedFrame()
        print("Current cube size: \(size)")
        self.addChild(cube)
//        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody = SKPhysicsBody()
        self.position.y = frame.maxY
        self.name = "Block"
        self.physicsBody?.categoryBitMask = 0x1 << 3
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysicalBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        self.physicsBody?.isDynamic = false
    }
}
