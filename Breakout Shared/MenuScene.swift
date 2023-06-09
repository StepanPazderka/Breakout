//
//  MenuScene.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 30.04.2023.
//

import SpriteKit

class MenuScene: SKScene {
    var router: Router?
    
    var gameTitle: SKLabelNode = {
        let label = SKLabelNode(text: "Bouncer")
        label.fontSize = 100.0
        label.fontColor = .white
        label.isHidden = false
        return label
    }()
    
    var newGameButton: SKButton = {
        let newGameButton = SKButton(text: "New Game")
        newGameButton.fontSize = 40.0
        newGameButton.fontColor = .red
        return newGameButton
    }()
    
    override func didMove(to view: SKView) {
        gameTitle.fontSize = 50
        gameTitle.position = CGPoint(x: size.width/2, y: frame.height - 150)
        self.backgroundColor = .lightGray
        newGameButton.action = { [weak self] in
            self?.router?.startNewGame()
        }
        
        newGameButton.onHoverAction = { button in
            let scaleUpAction = SKAction.scale(by: 1.1, duration: 0.1)
            button.run(scaleUpAction)
        }
        
        newGameButton.position = CGPoint(x: size.width/2, y: frame.midY)
    }

    override func update(_ currentTime: TimeInterval) {
        // called every frame
    }
    
    init(size: CGSize, router: Router) {
        self.router = router

        super.init(size: size)
        
        scene?.addChild(gameTitle)
        scene?.addChild(newGameButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
