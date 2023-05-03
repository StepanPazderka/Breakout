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
    
    override init() {
        super.init()
    }
    
    init(text: String, action: (() -> Void)? = nil) {
        super.init()
        self.text = text
        self.action = action
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
    
    override func mouseDown(with event: NSEvent) {
        action?()
    }
#endif
}
