//
//  GameScene.swift
//  LabelsTest
//
//  Created by Rubens Gondek on 5/14/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var curString:String = ""
    var myLabel:SKLabelNode!
    
    var scienceVector = ["A", "A", "A", "A", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.size = view.frame.size
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.name = "label"
        myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
        myLabel.physicsBody?.dynamic = false
        myLabel.text = curString
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:100);
        
        for i in 1...10 {
            self.criaLetraTeste(randomLetra())
        }
        
        self.addChild(myLabel)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if let body = physicsWorld.bodyAtPoint(location) {
                if body.node!.name == "letra" {
                    let nodinho = body.node as! LetraNode
                    let letrinha:String = nodinho.letra
                    println(letrinha)
                    self.curString = "\(curString)\(letrinha)"
                    self.myLabel.text = curString
                    self.myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
                    myLabel.physicsBody?.dynamic = false
                    

                }
                if body.node!.name == "label" {
                    let nodelinho: SKLabelNode = body.node! as! SKLabelNode
                    consultarDicionario(nodelinho.text)
                    curString = ""
                }
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func consultarDicionario(palavra: String){
        if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(palavra) {
            let ref = UIReferenceLibraryViewController(term: palavra)
            let pop = UIPopoverController(contentViewController: ref)
            pop.presentPopoverFromRect(CGRectMake(self.size.width/2, self.size.height - 150, 1, 1), inView: self.view!, permittedArrowDirections: UIPopoverArrowDirection.Down, animated: true)
        }
    }
    
    func criaLetraTeste(l:String){
        let letra = LetraNode(texture: SKTexture(imageNamed: "apple"), letra: l)
        letra.physicsBody = SKPhysicsBody(rectangleOfSize: letra.size)
        letra.physicsBody?.dynamic = false
        letra.name = "letra"
        let x = CGFloat(arc4random())%self.size.width
        let y = CGFloat(arc4random())%self.size.height
        println("\(x) y \(y)")
        letra.position = CGPointMake(x, y)
        self.addChild(letra)
        
        println(l)
    }
    
    func randomLetra() -> String {
        let ij:Float = Float(arc4random())%Float(scienceVector.count)
        return scienceVector[Int(ij)]
    }
}
