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
    
    func enclosePlayground() {
        var frame = self.frame
        frame.size.height += 100
        frame.origin.y -= 100
        let borderBody = SKPhysicsBody(edgeLoopFrom: frame)
        borderBody.friction = 0
        borderBody.categoryBitMask = 1
        self.physicsBody = borderBody
    }
    
    func setUpScene() {
        guard let frameWidth = self.view?.frame.width else { return }
        
        self.player = SKShapeNode(rectOf: CGSize(width: frameWidth / 3, height: 10), cornerRadius: 5.0)
        self.ball = SKShapeNode(circleOfRadius: 20.0)
        
        
        if let player = player, let ball = ball {
            player.lineWidth = 0.0
            player.fillColor = .red
            player.position.y = self.frame.minY + 100
            player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
            player.physicsBody?.isDynamic = false
            player.name = "Player"

            ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            ball.fillColor = .white
            ball.physicsBody?.friction = 0.0
            ball.physicsBody?.linearDamping = 0.0
            ball.physicsBody?.angularDamping = 0.0
            ball.physicsBody?.restitution = 1.0
            ball.physicsBody?.affectedByGravity = false
            ball.physicsBody?.mass = 0.0
            ball.name = "Ball"

            ball.physicsBody?.contactTestBitMask = 0x1
            
            self.addChild(player)
            self.addChild(ball)
                
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 1000.0))
        }
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var contactNodes = [SKNode]()
        if let nodA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            contactNodes.append(nodA)
            contactNodes.append(nodeB)
        }
        
        var bodies = [contact.bodyA, contact.bodyB]
        
        var edgeLoop = bodies.first(where: { $0.categoryBitMask == 1 })

        if let edgeLoop {
            print("Wall was hit")
            if contact.contactPoint.y < -(frame.height / 2) {
                var gameOverLabel = SKLabelNode(text: "Game Over")
                gameOverLabel.fontSize = 80.0
                gameOverLabel.fontColor = NSColor.white
                scene?.addChild(gameOverLabel)
                scene?.view?.isPaused = true
            }
        }
        
        var ballNode = contactNodes.first(where: { $0.name == "Ball" })
        var PlayerNode = contactNodes.first(where: { $0.name == "Player" })
        
        if let ballNode, let PlayerNode {
            print(contact.contactNormal)
            let positionDifference = (PlayerNode.position.x - ballNode.position.x)
            ball?.physicsBody?.applyImpulse(CGVector(dx: -1*(positionDifference*5), dy: 0.0))
        }
    }
    
    override func didMove(to view: SKView) {
        self.enclosePlayground()
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let ball {
//            print(ball.physicsBody?.velocity)
//            ball.fillColor = NSColor.init(red: CGFloat.random(in: 0.0...1.0), green: CGFloat.random(in: 0.0...1.0), blue: CGFloat.random(in: 0.0...1.0), alpha: CGFloat.random(in: 0.0...1.0))
            ball.lineWidth = 0.0
        }
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
//        print("Mouse movement")
        let point = event.locationInWindow as CGPoint
        print(point.x)
        player?.position.x = point.x - (player?.frame.size.width ?? 0 / 2)
        print(player?.position.x)
        
        // Get mouse position in scene coordinates
        //        let location = event.location(in: self)
        // Get node at mouse position
        //        let node = self.atPoint(location)
        // ...
    }
}
#endif

