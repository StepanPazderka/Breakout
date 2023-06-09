//
//  GameScene.swift
//  Breakout Shared
//
//  Created by Štěpán Pazderka on 26.04.2023.
//

import SpriteKit

class GameScene: SKScene {
    
    private var player = Player()
    private var ball = Ball()
    private var router: Router
    
    var gameOverLabel: SKLabelNode = {
        let label = SKLabelNode(text: "Game Over")
        label.fontSize = 50.0
        label.fontColor = .white
        label.isHidden = true
        return label
    }()

    var gameWon: SKLabelNode = {
        let label = SKLabelNode(text: "Game Won!")
        label.fontSize = 50.0
        label.fontColor = .white
        label.isHidden = true
        return label
    }()
    
    let numberOfRows = 1
    let numberOfColumns = 10
    
    var blocks: [SKNode] = [SKNode]()
    
    func setupBlocks() {
        let blockSide = frame.width / CGFloat(numberOfColumns)
        let padding = frame.width / blockSide
        let blockSize = CGSize(width: blockSide - padding, height: blockSide - padding)
        
        for row in 1...numberOfRows {
            print(row)
            for column in 1...numberOfColumns {
                let width = frame.width / (CGFloat(numberOfColumns) + 1.0)
                let block = Block(size: CGSize(width: width, height: width))
                
                let padding = width / CGFloat(numberOfColumns)
                
                block.position.x = (((padding+width)*CGFloat(column)) - width/2) - (padding/2)
                block.position.y = frame.maxY - (view?.safeAreaInsets.top ?? 0) - (frame.height/30)
                
                let rowOffset = block.frame.width * CGFloat(row) + 20
//                block.position.x = (padding*4) + (padding * CGFloat(column) - (padding / 2)) + frame.minX + ((blockSize.height * CGFloat(column)) - blockSize.height)
//                block.position.y = frame.maxY - blockSize.height - (self.view?.safeAreaInsets.top ?? 0.0) - (rowOffset) + ((padding * 2) / CGFloat(row))
                block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
                blocks.append(block)
                block.setupPhysicalBody()
            }
        }
        
        for block in blocks {
            scene?.addChild(block)
        }
        
        scene?.addChild(gameWon)
    }
    
    func setupGameOverScreen() {
        scene?.addChild(gameOverLabel)
    }
    
    init(size: CGSize, router: Router) {
        self.router = router
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func enclosePlayground() {
        let wallsNode = SKNode()
        var playgroundFrame = self.frame
        playgroundFrame.size.height += 100
        playgroundFrame.origin.y -= 100
        let gameMapEdge = SKPhysicsBody(edgeLoopFrom: playgroundFrame)
        gameMapEdge.categoryBitMask = 0x1 << 1
        gameMapEdge.friction = 0
        gameMapEdge.isDynamic = false
        gameMapEdge.collisionBitMask = 0x1 << 2
        gameMapEdge.contactTestBitMask = 10
//        self.physicsBody = gameMapEdge
        wallsNode.physicsBody = gameMapEdge
        wallsNode.name = "Walls"
        self.addChild(wallsNode)
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
        setupBlocks()
        setupGameOverScreen()
        self.player = Player()
        self.addChild(ball)
        self.backgroundColor = .lightGray
        ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -frame.height * 1.5))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        player.position.x = frame.midX
        player.position.y = frame.minY + 50
        self.addChild(player)
        
        physicsWorld.contactDelegate = self
    }
    
    // MARK: - Scene started
    override func didMove(to view: SKView) {
        self.enclosePlayground()
        self.setUpScene()
    }
    
    // MARK: - Update cycle
    override func update(_ currentTime: TimeInterval) {
        ball.yScale = CGFloat(1)
        ball.lineWidth = 0.0
        
        if blocks.isEmpty {
            gameWon.isHidden = false
            gameWon.position = CGPoint(x: frame.midX, y: frame.midY)
            scene?.isPaused = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.router.showMenu()
            }
        }
    }
    
#if os(OSX)
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            scene?.isPaused.toggle()
        }
    }
    
    override func mouseMoved(with event: NSEvent)
    {
        let point = event.locationInWindow as CGPoint
        player.position.x = convertPoint(fromView: point).x

        if gameOverLabel.isHidden == true {
            let point = event.locationInWindow as CGPoint
            player.position.x = convertPoint(fromView: point).x
        }
    }
#endif
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.player.position.x = touch.location(in: self).x
        }
    }
}
#endif


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var contactNodes = [SKNode]()
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            contactNodes.append(nodeA)
            contactNodes.append(nodeB)
        }
        
        let ballNode = contactNodes.first(where: { $0.name == "Ball" })
        let PlayerNode = contactNodes.first(where: { $0.name == "Player" })
        let blockNode = contactNodes.first(where: { $0.name == "Block" })
        let Walls = contactNodes.first(where: { $0.name == "Walls" })
        
        if let Walls {
            if contact.contactPoint.y < 30 {
                showGameOverScreen(value: true)
            }
        }
        
        if let ballNode, let PlayerNode {
            print("Contact")
            ballNode.physicsBody?.applyImpulse(CGVector(dx: (ballNode.position.x - PlayerNode.position.x)*2, dy: 0.0))
        }
        
        if let ballNode, let blockNode {
            blockNode.removeFromParent()
            let currentBlock = blocks.first(where: {$0 == blockNode})
            if let currentBlock {
                blocks.removeAll { node in
                    node == currentBlock
                }
            }
            print(currentBlock)
        }
    }
}
