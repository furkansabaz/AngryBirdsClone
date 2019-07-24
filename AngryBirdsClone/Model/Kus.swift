//
//  Kus.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 24.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import SpriteKit
enum KusTipi : String {
    
    case Yesil
    case Mavi
    case Turuncu
    case Kirmizi
}

class Kus : SKSpriteNode {
    
    let kusTipi : KusTipi
    init(kusTipi : KusTipi) {
        self.kusTipi = kusTipi
        
        let renk : UIColor!
        
        switch kusTipi {
        case .Yesil :
            renk = .green
        case .Mavi :
            renk = .blue
        case .Turuncu :
            renk = .orange
        case .Kirmizi :
            renk = .red
        }
        super.init(texture: nil, color: renk, size: CGSize(width: 40, height: 40))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Hata")
    }
    
}
