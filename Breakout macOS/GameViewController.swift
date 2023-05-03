//
//  GameViewController.swift
//  Breakout macOS
//
//  Created by Štěpán Pazderka on 26.04.2023.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    
    var boolMenuScreen = true
    var router: GameViewRouter!
    var cgSize: CGSize!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        cgSize = self.view.frame.size
        self.router = GameViewRouter(vc: self)
        let scene = GameScene(size: cgSize, router: router)
        let menu = MenuScene(size: cgSize, router: router)
        let skView = self.view as! SKView
        
        skView.presentScene(menu)
        boolMenuScreen = true
        
        // Create a new tracking area for the SKView
        let trackingArea = NSTrackingArea(rect: skView.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        skView.addTrackingArea(trackingArea)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    // Add a mouseEntered and mouseExited event handler to the SKView
    override func mouseEntered(with event: NSEvent) {
        if boolMenuScreen {
            NSCursor.unhide()
        } else {
            NSCursor.hide()
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        NSCursor.unhide()
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

