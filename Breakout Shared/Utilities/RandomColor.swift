//
//  RandomColor.swift
//  Breakout
//
//  Created by Štěpán Pazderka on 30.04.2023.
//

import SpriteKit

#if os(OSX)
    func randomColor() -> NSColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
#endif
#if os(iOS) || os(tvOS)
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
#endif
