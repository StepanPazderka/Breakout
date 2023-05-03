//
//  GameViewRouter.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 01.05.2023.
//

import SpriteKit

class GameViewRouter {

    let vc: GameViewController!
    
    init(vc: GameViewController) {
        self.vc = vc
    }
    
    func startNewGame() {
        vc.presentGameView()
    }
    
    func showMenu() {
        vc.showMenu()
    }
}
