//
//  LetraNode.swift
//  LabelsTest
//
//  Created by Rubens Gondek on 5/14/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class LetraNode: SKSpriteNode {
    
    var label:SKLabelNode!
    var labelREMOVER : SKLabelNode!
    var letra:String!
    var timer : NSTimer?
    var timeLeft = 60.00
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(texture:SKTexture, letra:String, tam:CGFloat){
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        //self.size = CGSizeMake(80, 80)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(tam, tam))
        self.physicsBody?.dynamic = false
        self.name = "letra"
        self.letra = letra
        self.label = SKLabelNode(fontNamed: "Helvetica")
        label.text = letra
        label.position = CGPointMake(0,0)
        self.addChild(label)
        
        //Remover depois:
        self.createTimer();
        labelREMOVER = SKLabelNode(fontNamed: "Comic Sans")//AYY
        labelREMOVER.position = CGPointMake(10, 10)
        labelREMOVER.text = "lol"
        self.addChild(labelREMOVER);
    }
    
    func createTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "mudaTempo", userInfo: nil, repeats: true)
    }
    
    func mudaTempo(){
        if(timeLeft > 0){
            timeLeft -= 0.5;
            labelREMOVER.text = "\(Int(timeLeft))";
        } else {
            println("Perdeu lol");
        }
    }
    
}
