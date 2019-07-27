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
    var kuslar = [
    Kus(kusTipi: .Kirmizi),
    Kus(kusTipi: .Gri),
    Kus(kusTipi: .Mavi),
    Kus(kusTipi: .Sari)
    ]
    
    let anchor = SKNode()
    
    var oyunDurumu : OyunDurumu = .Hazir
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        setupLevel()
        hazirlaGR()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        switch oyunDurumu {
            
        case .Hazir :
            if let touch = touches.first {
                let konum = touch.location(in: self)
                if kus.contains(konum) {
                    panGR.isEnabled = false
                    kus.secildiMi = true
                    kus.position = konum
                }
            }
            break
        case .Ucuyor :
            break
        case .Bitis :
            guard let view = view else {return}
            oyunDurumu = .Dirilme
            let kameraGeriAction = SKAction.move(to: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), duration: 2.0)
            kameraGeriAction.timingMode = .easeInEaseOut
            oyunKamera.run(kameraGeriAction, completion: {
                self.panGR.isEnabled = true
                self.kusEkle()
            })
            break
        case .Dirilme :
            break
            
        }
        
        
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
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
            oyunDurumu = .Ucuyor
            
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
        
        for node in mapNode.children {
            
            if let node = node as? SKSpriteNode {
                
                guard let adi = node.name else { continue}
                
                let bloklar = ["Cam","Tas","Tahta"]
                
                if !bloklar.contains(adi) { continue }
                
                
                guard let blokTipi = BlokTipi(rawValue: adi) else { continue }
                
                print("Geldi")
                let blok = Blok(tipi: blokTipi)
                
                
                blok.position = node.position
                blok.size = node.size
                blok.zPosition = ZPozisyon.engeller
                blok.zRotation = node.zRotation
                blok.bodyOlustur()
                mapNode.addChild(blok)
                node.removeFromParent()
        
                
                
            }
            
            
        }
        
        
        
        
        
        
        let rect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height - mapNode.tileSize.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        
        print(mapNode.tileSize.height)
        print(mapNode.frame.size.width)
        print(mapNode.frame.size.height)
        
        
        physicsBody?.categoryBitMask = FizikKategorileri.kenar
        physicsBody?.contactTestBitMask = FizikKategorileri.kus | FizikKategorileri.blok
        physicsBody?.collisionBitMask = FizikKategorileri.tumu
        
        
        anchor.position = CGPoint(x: frame.width/2, y: frame.height/2)
        addChild(anchor)
        kusEkle()
    }
    
    func kusEkle(){
        
        if kuslar.isEmpty {
            print("Hakkınız Bitti")
            return
        }
        kus = kuslar.removeFirst()
        oyunDurumu = .Hazir
        
        kus.physicsBody = SKPhysicsBody(rectangleOf: kus.size)
        kus.physicsBody?.categoryBitMask = FizikKategorileri.kus
        kus.physicsBody?.contactTestBitMask = FizikKategorileri.tumu
        kus.physicsBody?.collisionBitMask = FizikKategorileri.blok | FizikKategorileri.kenar
        kus.physicsBody?.isDynamic = false
        
        kus.position = anchor.position
        kus.olceklendir(boyut: mapNode.tileSize, genislik: true, oran: 1.0)
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
    
    override func didSimulatePhysics() {
        guard let body = kus.physicsBody else { return }
        
        if oyunDurumu == .Ucuyor && body.isResting {
            oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
            kus.removeFromParent()
            oyunDurumu = .Bitis
        }
        
    }
}



extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
            
        case FizikKategorileri.kus | FizikKategorileri.blok , FizikKategorileri.blok | FizikKategorileri.kenar:
            
            if let blok = contact.bodyA.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            } else if let blok = contact.bodyB.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            }
            break
            
            
        case FizikKategorileri.blok | FizikKategorileri.blok :
            
            if let blok = contact.bodyA.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            }
            if let blok = contact.bodyB.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            }
            break
        
        case FizikKategorileri.kus | FizikKategorileri.kenar :
            kus.ucuyorMu = false
            break
        default :
            break
            
        }
        
        
    }
}
