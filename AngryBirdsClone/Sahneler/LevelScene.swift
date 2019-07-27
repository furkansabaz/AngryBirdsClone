//
//  LevelScene.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 27.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    var sahneYoneticiDelegate : SahneYoneticiDelegate?
    
    
    override func didMove(to view: SKView) {
        levelSahneGetir()
    }
    
    func levelSahneGetir() {
        
        
        let satirBaslangicNoktasi = frame.midY*3/2
        let sutunBaslangicNoktasi = frame.midX/2
        
        var level = 1
        
        for satir in 0...2 {
            for sutun in 0...2 {
                
                
                let btnLevel = SKButton(varsayilanButonAdi: "tahtaButon", calistir: oyunSahnesineGit, index: level)
                btnLevel.position = CGPoint(x: CGFloat(sutun)*sutunBaslangicNoktasi + sutunBaslangicNoktasi, y: satirBaslangicNoktasi - CGFloat(satir)*frame.midY/2)
                
                btnLevel.zPosition = ZPozisyon.oyunDisiArkaPlan
                
                addChild(btnLevel)
                
                
                let lblLevel = SKLabelNode(fontNamed: "AvenirNext-Bold")
                lblLevel.color = .white
                lblLevel.text = "\(level)"
                lblLevel.verticalAlignmentMode = .center
                lblLevel.horizontalAlignmentMode = .center
                lblLevel.fontSize = 200.0
                lblLevel.olceklendir(boyut: btnLevel.size, genislik: false, oran: 0.45)
                
                lblLevel.zPosition = ZPozisyon.labelMenu
                
                btnLevel.addChild(lblLevel)
                
                btnLevel.olceklendir(boyut: frame.size, genislik: false, oran: 0.25)
                level = level + 1
            }
            
        }
        
    }
    
    func oyunSahnesineGit(level : Int) {
        
    sahneYoneticiDelegate?.gosterOyunSahnesi(level: level)
    }
    
}
