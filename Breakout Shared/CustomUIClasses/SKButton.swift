//
//  SKButton.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 01.05.2023.
//

import SpriteKit
#if os(iOS) || os(tvOS)
import UIKit
#endif

class SKButton: SKLabelNode {
    public var action: (() -> Void)?
    public var onHoverAction: ((SKNode) -> Void)?
    var onHoverActive = false
    
    override init() {
        super.init()
    }
    
    init(text: String, action: (() -> Void)? = nil, onHover: ((SKNode) -> Void)? = nil) {
        super.init()
        self.text = text
        self.action = action
        self.onHoverAction = onHover
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
#if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action?()
    }
#endif
    
#if os(OSX)
    override func touchesBegan(with event: NSEvent) {
        action?()
    }
    
    override func mouseMoved(with event: NSEvent) {
        if onHoverActive == false {
            onHoverAction?(self)
        }
        onHoverActive = true
    }
    
    override func mouseExited(with event: NSEvent) {
        onHoverActive = false
        let resetAction = SKAction.scale(by: 1.0, duration: 0.1)
        self.run(resetAction)
    }

    override func mouseDown(with event: NSEvent) {
        action?()
    }
#endif
}
