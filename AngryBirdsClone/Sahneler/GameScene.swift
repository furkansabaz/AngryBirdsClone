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
    var pinchGR = UIPinchGestureRecognizer()
    
    var maxOlcek : CGFloat = 0
    
    var kus = Kus(kusTipi: .Mavi)
    let anchor = SKNode()
    override func didMove(to view: SKView) {
        setupLevel()
        hazirlaGR()
    }
    
    func kameraEkle() {
        
        addChild(oyunKamera)
        guard let view = view else {return}
        oyunKamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        camera = oyunKamera
    }
    
    func hazirlaGR() {
        
        guard let view = view else {return}
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
        
        pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchGR)
    }
    
    @objc func pinch(p : UIPinchGestureRecognizer) {
        
        guard let view = view else { return }
        if p.numberOfTouches == 2 { //Kullanıcının ekranda dokunduğu nokta sayısı
            
            let konumView = p.location(in: view) // pinch işleminin hangi konumda olduğunu verir
            let konum = convertPoint(fromView: konumView) // pinch ölçeklendirme işlemi yapmadan önceki konumu verir
            
            if p.state  == .changed {
                
                let olcek = 1 / p.scale // bu ölçeği kameranın yeni göstereceği ölçeği hesaplamak için tanımladık
                let yeniOlcek = oyunKamera.yScale*olcek
                
                print("Yeni Ölçek :  \(yeniOlcek)")
                if yeniOlcek < maxOlcek && yeniOlcek > 0.5 {
                    oyunKamera.setScale(yeniOlcek)
                }
                
                
                let olcekSonrasiKonum = convertPoint(fromView: konumView)
                
                let konumDelta  = konum - olcekSonrasiKonum
                let yeniKonum = oyunKamera.position + konumDelta
                
                
                oyunKamera.position = yeniKonum
                p.scale = 1.0
                oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
            }
            
        }
        
        
        
    }
    @objc func pan(p : UIPanGestureRecognizer) {
        
        guard let view = view else {return}
        
        let hareket = p.translation(in: view) * oyunKamera.yScale
        oyunKamera.position = CGPoint(x: oyunKamera.position.x-hareket.x, y: oyunKamera.position.y + hareket.y)
        oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
        p.setTranslation(CGPoint.zero, in: view)
    }
    
    func setupLevel() {
        
        if let map = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = map
            maxOlcek = mapNode.mapSize.width / frame.size.width
            print(maxOlcek)
        }
        kameraEkle()
        
        anchor.position = CGPoint(x: mapNode.frame.midX, y: mapNode.frame.midY)
        addChild(anchor)
        kusEkle()
    }
    
    func kusEkle(){
        kus.position = anchor.position
        addChild(kus)
    }
}
