//
//  LexTest.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 21/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import Foundation

import SpriteKit

let projectileCategory:UInt32 =  0b0000001//0b001
let obstacleCategory:UInt32 =  0b0000010//0b010
let playerCategory:UInt32 = 0b0000100//0b011
let bossCategory:UInt32 = 0b0001000//0b100
let enemyCategory:UInt32 = 0b0010000//0b101
let enemyProjectileCategory:UInt32 = 0b0100000//0b110
let invulnerableCategory:UInt32 = 0b1000000//0b101010


class LexTest:SKScene, SKPhysicsContactDelegate {
    var vc : GameViewController?
    var enemy:EnemyNode? = nil
    var player:LexicusNode!
    var telaNode:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.size = view.frame.size
        
        self.physicsWorld.contactDelegate = self
        
        telaNode = SKSpriteNode(imageNamed: "square")
        telaNode.size = CGSizeMake(self.size.width*0.8, self.size.height*0.3)
        telaNode.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(telaNode)
        
        player = LexicusNode(texture: SKTexture(imageNamed: "fausto"), tam: 80)
        player.size = CGSizeMake(60, 60)
        player.position = CGPointMake(-telaNode.size.width/2 + CGFloat(40), -telaNode.size.height/2 + CGFloat(40))
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = enemyCategory
        telaNode.addChild(player)
        
        
        self.createEnemy()
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            self.eventoToque(location)
        }
    }
    
//    func didBeginContact(contact: SKPhysicsContact) {
//        
//        let firstBody, secondBody:SKPhysicsBody
//        
//        //descobre qual corpo é qual
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
//        }
//        else{
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
//        }
//        
//        //faz a magia acontecer
//        if firstBody.categoryBitMask == projectileCategory && secondBody.categoryBitMask == enemyCategory{
//            if (firstBody.node != nil){
//                self.enemyHit()
//            }
//        }
//        
//        if firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == enemyCategory{
//            if (firstBody.node != nil){
//                //player hit
//            }
//        }
//        
//    }
    
    func createEnemy(){
        if enemy == nil{
            enemy = EnemyNode(texture: SKTexture(imageNamed: "churrasqueira"), tam: CGFloat(40))
            enemy?.name = "enemy"
            enemy!.size = CGSizeMake(40, 40)
            enemy!.position = CGPointMake(telaNode.size.width/2 - CGFloat(40), -telaNode.size.height/2 + CGFloat(40))
            enemy!.physicsBody = SKPhysicsBody(rectangleOfSize: enemy!.size)
            enemy!.physicsBody?.dynamic = false
            enemy!.physicsBody?.categoryBitMask = enemyCategory
            enemy!.physicsBody?.contactTestBitMask = playerCategory | projectileCategory
            telaNode.addChild(enemy!)
        }
    }
  
    
    func eventoToque(locationGrid:CGPoint){
        self.player.fire(enemy!, tela: self.telaNode)
    }
    
    var lastUpdateTimeInterval:NSTimeInterval = 0.0
    var timeSinceLast:NSTimeInterval = 0
    var prevSeconds:Int = -1
    override func update(currentTime: CFTimeInterval) {
        
        timeSinceLast = currentTime - self.lastUpdateTimeInterval
        self.lastUpdateTimeInterval = currentTime;
        
        if (enemy != nil){
            self.enemy!.runBehavior(self)
        }
        
    }
    
    func enemyHit(){
        
        self.telaNode.childNodeWithName("enemy")?.removeFromParent()
        enemy = nil
        self.createEnemy()
    }
    
    
}



