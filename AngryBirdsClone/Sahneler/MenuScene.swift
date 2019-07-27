//
//  MenuScene.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 27.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene {
    var sahneYoneticiDelegate : SahneYoneticiDelegate?
    
    override func didMove(to view: SKView) {
        menuGoster()
    }
    
    func menuGoster() {
        let btnOynat = SKButton(varsayilanButonAdi: "oynatButonu", calistir: levelSahnesineGit, index: 0)
        
        btnOynat.position = CGPoint(x: frame.midX, y: frame.midY)
        btnOynat.olceklendir(boyut: frame.size, genislik: false, oran: 0.3)
        addChild(btnOynat)
    }
    
    func levelSahnesineGit(_ : Int) {
        sahneYoneticiDelegate?.gosterLevelSahnesi()
    }
    
}
