//
//  Random.swift
//  FlappyBird
//
//  Created by Bao Vu on 2/19/20.
//  Copyright © 2020 Bao Vu. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    public static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    static func random(min : CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}
