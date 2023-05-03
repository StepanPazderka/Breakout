//
//  GameScene.swift
//  Breakout Shared
//
//  Created by Štěpán Pazderka on 26.04.2023.
//

import SpriteKit
import SwiftUI
import Combine

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
    fileprivate var ball = Ball()
    var router: GameViewRouter
    
    var gameOverLabel: SKLabelNode = {
        let label = SKLabelNode(text: "Game Over")
        label.fontSize = 80.0
        label.fontColor = .white
        label.isHidden = true
        return label
    }()
    var restartButton: SKSpriteNode?
    
    let rows = 20
    let columns = 10
    
    var blocks: [SKShapeNode] = [SKShapeNode]()
    
    func setupBlocks() {
        for i in 0...columns {
            let block = Block(size: CGSize(width: (frame.width/CGFloat(columns) - 20.0), height: frame.height/CGFloat(rows)))
            block.position.x = (10 * CGFloat(i)) + frame.minX + (block.frame.width * CGFloat(i))
            block.position.y = frame.maxY - block.frame.size.height
            block.setupPhysicalBody()
            blocks.append(block)
        }
        
        for block in blocks {
            scene?.addChild(block)
        }
    }
    
    func setupGameOverScreen() {
        scene?.addChild(gameOverLabel)
    }
    
    func squashBall(impulse: CGVector) {
        let originalVelocity = ball.physicsBody?.velocity
        let squashAction = SKAction.scaleY(to: 0.5, duration: 0.1)
        let waitAction = SKAction.wait(forDuration: 0.1)
        let stretchAction = SKAction.scaleY(to: 1.0, duration: 0.1)
        let sequence = SKAction.sequence([squashAction, waitAction, stretchAction])
        ball.run(sequence) {
            self.ball.physicsBody = SKPhysicsBody(circleOfRadius: 20) // Re-add the physics body
            if let originalVelocity {
                self.ball.physicsBody?.velocity = originalVelocity
            }
        }
        ball.physicsBody?.applyImpulse(impulse)
    }
    
    init(size: CGSize, router: GameViewRouter) {
        self.router = router
        
        super.init(size: size)
        
        setUpScene()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        //        scene.view?.preferredFrameRate = 120
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
    
    func showGameOverScreen(value: Bool) {
        gameOverLabel.isHidden = !value
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scene?.isPaused = value
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.router.showMenu()
        }
    }
    
    func setUpScene() {
        guard let frameWidth = self.view?.frame.width else { return }
        setupBlocks()
        setupGameOverScreen()
        
        self.player = SKShapeNode(rectOf: CGSize(width: frameWidth / 3, height: 10), cornerRadius: 5.0)

        if let player = player {
            player.lineWidth = 0.0
            player.fillColor = .red
            player.position.y = self.frame.minY + 100
            player.position.x = self.frame.midX
            player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
            player.physicsBody?.isDynamic = false
            player.name = "Player"
            
            ball.fillColor = .white
            ball.position.x = frame.midX
            ball.position.y = frame.midY
            
            self.addChild(player)
            self.addChild(ball)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 1000.0))
        }
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var contactNodes = [SKNode]()
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            contactNodes.append(nodeA)
            contactNodes.append(nodeB)
        }
        
        let bodies = [contact.bodyA, contact.bodyB]
        
        let edgeLoop = bodies.first(where: { $0.categoryBitMask == 1 })
        
        if let edgeLoop {
            print("Wall was hit")
            if contact.contactPoint.y < 30 {
                showGameOverScreen(value: true)
                
                //                scene?.view?.isPaused.toggle()
            }
            
        }
        
        var ballNode = contactNodes.first(where: { $0.name == "Ball" })
        var PlayerNode = contactNodes.first(where: { $0.name == "Player" })
        var BlockNode = contactNodes.first(where: { $0.name == "Block" })
        
        if let ballNode, let PlayerNode {
            print(contact.contactNormal)
            
            let positionDifference = (PlayerNode.position.x - ballNode.position.x)
            let impulseVector = CGVector(dx: -1*(positionDifference*5), dy: 0.0)
            ballNode.physicsBody?.applyImpulse(impulseVector)
        }
        
        if let ballNode, let BlockNode {
            BlockNode.removeFromParent()
        }
    }
    
    override func didMove(to view: SKView) {
        self.enclosePlayground()
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        ball.yScale = CGFloat(1)
        //            print(ball.physicsBody?.velocity)
        //            ball.fillColor = NSColor.init(red: CGFloat.random(in: 0.0...1.0), green: CGFloat.random(in: 0.0...1.0), blue: CGFloat.random(in: 0.0...1.0), alpha: CGFloat.random(in: 0.0...1.0))
        ball.lineWidth = 0.0
        
    }
    
    #if os(OSX)
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            scene?.isPaused.toggle()
        }
    }
    #endif
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
        //        scene?.isPaused.toggle()
        //        gameOverLabel.isHidden.toggle()
        //        let newLabel = SKLabelNode(text: "Kaussar")
        //        newLabel.fontSize = 500
        //        scene?.addChild(newLabel)
        //        let location = event.location(in: self)
        //        guard let restartButton = self.restartButton else { return }
        //        if restartButton.contains(location) {
        //            ball.position = CGPoint(x: frame.midX, y: frame.midY)
        //            scene?.isPaused = false
        //            let listChidlren = [restartButton, gameOverLabel]
        //
        //            scene?.removeChildren(in: listChidlren)
        //        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        //        print("Mouse dragged")
    }
    
    override func mouseUp(with event: NSEvent) {
        //        print("Mouse Up")
    }
    
    override func mouseMoved(with event: NSEvent)
    {
        if gameOverLabel.isHidden == true {
            let point = event.locationInWindow as CGPoint
            print("Mouse position: \(point.x)")
            print("Player position: \(player!.position.x)")
            player?.position.x = convertPoint(fromView: point).x
        }
    }
}
#endif

