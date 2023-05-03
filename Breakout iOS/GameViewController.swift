//
//  GameViewController.swift
//  Breakout iOS
//
//  Created by Štěpán Pazderka on 26.04.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var boolMenuScreen = true
    var cgSize: CGSize!
    var router: GameViewRouter!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cgSize = self.view.frame.size
        self.router = GameViewRouter(vc: self)
        let scene = GameScene(size: cgSize, router: router)
        let menu = MenuScene(size: cgSize, router: router)
        let skView = self.view as! SKView
        
        skView.presentScene(menu)
        boolMenuScreen = true
        
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func presentGameView() {
        let scene = GameScene(size: cgSize, router: router)
        let skView = self.view as! SKView
        
        skView.presentScene(scene)
    }
    
    func showMenu() {
        let menu = MenuScene(size: cgSize, router: router)
        let skView = self.view as! SKView
        
        skView.presentScene(menu)
    }
}
