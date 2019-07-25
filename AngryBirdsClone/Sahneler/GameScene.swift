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
    var i = 1
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        i = i + 1
        print("Dokundun-\(i+1)")
        if let touch = touches.first {
            let konum = touch.location(in: self)
            if kus.contains(konum) {
                print("Kuş Seçildi")
                panGR.isEnabled = false
                kus.secildiMi = true
                kus.position = konum
            }
        }
    }
    
    var k = 1
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        k = k + 1
        print("Moved-\(k)")
        
        if let touch = touches.first {
            
            if kus.secildiMi {
                let konum = touch.location(in: self)
                kus.position = konum
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if kus.secildiMi {
            
            oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: kus)
            
            kus.secildiMi = false
            panGR.isEnabled = true
            anchorSinirlariniBelirle(aktif: false)
            
            kus.ucuyorMu = true
            
            let xFark = anchor.position.x - kus.position.x
            let yFark = anchor.position.y - kus.position.y
            
            let impulse = CGVector(dx: xFark, dy: yFark)
            kus.physicsBody?.applyImpulse(impulse)
            kus.isUserInteractionEnabled = false
            
            
            
        }
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
                
                //print("Yeni Ölçek :  \(yeniOlcek)")
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
            //print(maxOlcek)
        }
        kameraEkle()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: mapNode.frame)
        physicsBody?.categoryBitMask = FizikKategorileri.kenar
        physicsBody?.contactTestBitMask = FizikKategorileri.kus | FizikKategorileri.blok
        physicsBody?.collisionBitMask = FizikKategorileri.tumu
        
        
        anchor.position = CGPoint(x: mapNode.frame.midX, y: mapNode.frame.midY)
        addChild(anchor)
        kusEkle()
    }
    
    func kusEkle(){
        
        kus.physicsBody = SKPhysicsBody(rectangleOf: kus.size)
        kus.physicsBody?.categoryBitMask = FizikKategorileri.kus
        kus.physicsBody?.contactTestBitMask = FizikKategorileri.tumu
        kus.physicsBody?.collisionBitMask = FizikKategorileri.blok | FizikKategorileri.kenar
        kus.physicsBody?.isDynamic = false
        
        kus.position = anchor.position
        addChild(kus)
        anchorSinirlariniBelirle(aktif: true)
    }
    
    func anchorSinirlariniBelirle(aktif : Bool) {
        
        if aktif {
            
            let gerilmeAralik = SKRange(lowerLimit: 0.0, upperLimit: kus.size.width*2.8)
            
            let kusConstraint = SKConstraint.distance(gerilmeAralik, to: anchor)
            kus.constraints = [kusConstraint]
        } else {
            kus.constraints?.removeAll()
        }
    }
    
    
}
