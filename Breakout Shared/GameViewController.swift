//
//  GameViewController.swift
//  Breakout macOS
//
//  Created by Štěpán Pazderka on 26.04.2023.
//

#if os(OSX)
import Cocoa
typealias ViewController = NSViewController
#endif
#if os(iOS) || os(tvOS)
import UIKit
typealias ViewController = UIViewController
#endif
import SpriteKit
import GameplayKit


class GameViewController: ViewController {
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
        
#if os(OSX)
        // Create a new tracking area for the SKView
        let trackingArea = NSTrackingArea(rect: skView.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        skView.addTrackingArea(trackingArea)
#endif
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
#if os(OSX)
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
#endif
    
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

