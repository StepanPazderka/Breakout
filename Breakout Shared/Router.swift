//
//  GameViewRouter.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 01.05.2023.
//

import SpriteKit

class Router {

    let viewController: GameViewController!
    
    init(vc: GameViewController) {
        self.viewController = vc
    }
    
    func startNewGame() {
        viewController.presentGameView()
    }
    
    func showMenu() {
        viewController.showMenu()
    }
}
