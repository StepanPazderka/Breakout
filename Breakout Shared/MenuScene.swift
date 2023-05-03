//
//  MenuScene.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 30.04.2023.
//

import SpriteKit

class MenuScene: SKScene {
    var router: GameViewRouter?
    
    var gameTitle: SKLabelNode = {
        let label = SKLabelNode(text: "Bouncer")
        label.fontSize = 80.0
        label.fontColor = .white
        label.isHidden = false
        return label
    }()
    
    var newGameButton: SKButton = {
        let newGameButton = SKButton(text: "New Game")
        newGameButton.fontSize = 50.0
        newGameButton.fontColor = .blue
        return newGameButton
    }()
    
    override func didMove(to view: SKView) {
        // create a label node
//        let gameOverLabel = SKLabelNode(fontNamed: "Arial")
        gameTitle.fontSize = 50
        gameTitle.position = CGPoint(x: size.width/2, y: frame.height - 100)
        
        newGameButton.action = { [weak self] in
            self?.router?.startNewGame()
        }
        newGameButton.position = CGPoint(x: size.width/2, y: gameTitle.position.y - 200)
        // add the label node to the scene
        scene?.addChild(gameTitle)
        scene?.addChild(newGameButton)
    }

    override func update(_ currentTime: TimeInterval) {
        // called every frame
    }
    
    init(size: CGSize, router: GameViewRouter) {
        self.router = router
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
