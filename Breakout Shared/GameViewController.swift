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
    var router: Router!
    var cgSize: CGSize!
    lazy var menuScene = MenuScene(size: cgSize, router: router)

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cgSize = self.view.frame.size
        self.router = Router(vc: self)
        let skView = self.view as! SKView
        skView.presentScene(menuScene)
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
    override func mouseMoved(with event: NSEvent) {
        print("Mouse in window")
    }
    
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
        let skView = self.view as! SKView
        let newGameScene = GameScene(size: cgSize, router: router)
        skView.presentScene(newGameScene)
    }
    
    func showMenu() {
        let skView = self.view as! SKView
        skView.presentScene(menuScene)
    }
}

