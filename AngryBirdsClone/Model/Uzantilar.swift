//
//  Uzantilar.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 24.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    static public func +(sol : CGPoint, sag : CGPoint) -> CGPoint {
        return CGPoint(x: sol.x+sag.x, y: sol.y+sag.y)
    }
    static public func -(sol : CGPoint, sag : CGPoint) -> CGPoint {
        return CGPoint(x: sol.x-sag.x, y: sol.y-sag.y)
    }
    
    
    
    static public func *(sol : CGPoint, sag : CGFloat) -> CGPoint {
        return CGPoint(x: sol.x*sag, y: sol.y*sag)
    }
}
