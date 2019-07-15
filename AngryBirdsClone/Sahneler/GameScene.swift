//
//  GameScene.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 12.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    let oyunKamera = OyunKamera()
    
    var mapNode = SKTileMapNode()
    
    var panGR = UIPanGestureRecognizer()
    
    override func didMove(to view: SKView) {
        setupLevel()
        hazirlaGR()
    }
    
    func kameraEkle() {
        
        addChild(oyunKamera)
        
        guard let view = view else {return}
        
        camera = oyunKamera
    }
    
    func hazirlaGR() {
        
        guard let view = view else {return}
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
        
    }
    
    @objc func pan(p : UIPanGestureRecognizer) {
        
        guard let view = view else {return}
        
        let hareket = p.translation(in: view)
        oyunKamera.position = CGPoint(x: oyunKamera.position.x-hareket.x, y: oyunKamera.position.y + hareket.y)
        oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
        p.setTranslation(CGPoint.zero, in: view)
    }
    
    func setupLevel() {
        
        if let map = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = map
        }
        kameraEkle()
        
    }
    
}
