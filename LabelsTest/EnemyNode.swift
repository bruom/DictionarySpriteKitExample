
//
//  EnemyNode.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/21/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class EnemyNode:SKSpriteNode {
    
    //intervalo entre disparos
    let INTERVAL:Double = 5.0
    
    var reloadTime:Double = 5.0
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(texture:SKTexture, tam:CGFloat){
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSizeMake(tam, tam)
        
    }
    
    func runBehavior(scene:SKScene) {
        let gameScene = scene as! Bookworm
        self.reload(gameScene.timeSinceLast)
        self.avancar()
        
    }
    
    func avancar(){
        if reloadTime <= 0.0 {
            let moveAction = SKAction.moveTo(CGPointMake(self.position.x - 80, self.position.y), duration: 0.8)
            self.runAction(moveAction)
            self.reloadTime = self.INTERVAL
        }
        
    }
    
    func reload(time:NSTimeInterval){
        if reloadTime > 0.0 {
            reloadTime -= time
        }
    }
    
    func getHit(){
        //animacoes e tal
        self.removeFromParent()
    }
    
}
