//
//  GameScene.swift
//  Breakout Shared
//
//  Created by Štěpán Pazderka on 26.04.2023.
//

import SpriteKit

#if os(OSX)
extension SKView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.acceptsMouseMovedEvents = true
    }
}
#endif

class GameScene: SKScene, SKPhysicsContactDelegate {
    fileprivate var player: SKShapeNode?
    fileprivate var ball: SKShapeNode?
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        guard let frameWidth = self.view?.frame.width else { return }
        
        self.player = SKShapeNode(rectOf: CGSize(width: frameWidth / 2, height: 10), cornerRadius: 5.0)
        self.ball = SKShapeNode(circleOfRadius: 10.0)
        
        if let player = player, let ball = ball {
            player.lineWidth = 0.0
            player.fillColor = .red
            player.position.y = self.frame.minY + 100
            player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
            player.physicsBody?.isDynamic = false
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
            ball.physicsBody?.restitution = 1.05
            player.physicsBody?.restitution = 1.05
            ball.physicsBody?.friction = 0.0
            ball.physicsBody?.velocity = CGVector(dx: 2.0, dy: 2.0)
            player.physicsBody?.friction = 0.0
            ball.physicsBody?.angularDamping = 1.0
            player.physicsBody?.angularDamping = 1.0
            ball.fillColor = .white
            player.physicsBody?.categoryBitMask = 0x2
            player.physicsBody?.contactTestBitMask = 0x1
            
            self.addChild(player)
            self.addChild(ball)
        }
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact \(Date())")
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.player?.position.x = t.location(in: self).x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        print("Mouse Down")
    }
    
    override func mouseDragged(with event: NSEvent) {
        print("Mouse dragged")
    }
    
    override func mouseUp(with event: NSEvent) {
        print("Mouse Up")
    }
    
    override func mouseMoved(with event: NSEvent)
    {
        print("Mouse movement")
        let point = event.locationInWindow as CGPoint
        player?.position.x = point.x - (player?.frame.size.width ?? 0)
        // Get mouse position in scene coordinates
        //        let location = event.location(in: self)
        // Get node at mouse position
        //        let node = self.atPoint(location)
        // ...
    }
}
#endif

