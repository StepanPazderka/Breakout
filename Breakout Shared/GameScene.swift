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

class GameScene: SKScene {
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    
    fileprivate var player : SKShapeNode?

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
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w))
        
        guard let frameWidth = self.view?.frame.width else { return }
        
        self.player = SKShapeNode(rectOf: CGSize(width: frameWidth / 2, height: 10), cornerRadius: 5.0)

        if let player = player {
            player.lineWidth = 0.0
            player.fillColor = .red
            player.position.y = self.frame.minY + 100
            self.addChild(player)
            
        }
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
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

