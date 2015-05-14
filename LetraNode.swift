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
    var letra:String!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(texture:SKTexture, letra:String){
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSizeMake(80, 80)
        
        self.letra = letra
        self.label = SKLabelNode(fontNamed: "Helvetica")
        label.text = letra
        label.position = CGPointMake(0,0)
        self.addChild(label)
    }
    
}