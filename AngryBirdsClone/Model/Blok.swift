//
//  Blok.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 26.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import SpriteKit




class Blok : SKSpriteNode {
    
    let tipi : BlokTipi
    var cani : Int
    let hasarDegeri : Int
    
    
    init(tipi : BlokTipi) {
        self.tipi = tipi
        
        switch tipi {
            
        case .Cam :
            cani = 70
            break
        case .Tahta :
            cani = 250
            break
        case .Tas :
            cani = 450
            break
        }
        
        hasarDegeri = (2*cani)/5
        super.init(texture: nil, color: .clear, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func bodyOlustur() {
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = FizikKategorileri.blok
        physicsBody?.contactTestBitMask = FizikKategorileri.tumu
        physicsBody?.collisionBitMask = FizikKategorileri.tumu
    }
}


enum BlokTipi : String {
    case Tas
    case Cam
    case Tahta
    
}
