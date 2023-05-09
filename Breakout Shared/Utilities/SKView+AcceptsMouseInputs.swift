//
//  SKView+AcceptsMouseInputs.swift
//  Breakout iOS
//
//  Created by Štěpán Pazderka on 08.05.2023.
//

import SpriteKit

#if os(OSX)
extension SKView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.acceptsMouseMovedEvents = true
    }
}
#endif
