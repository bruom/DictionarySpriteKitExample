//
//  Tile.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/15/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class Tile:NSObject {
    var xCoord:CGFloat!
    var yCoord:CGFloat!
    var x:Int!
    var y:Int!
    
    //preview de letra, serve para planejar a posicao das letras sem ter que criar nodes
    var letraPrev:String!
    
    var content:LetraNode?
    
    var isActive:Bool!
    
    init(xC:CGFloat, yC:CGFloat, xPos:Int, yPos:Int) {
        super.init()
        xCoord = xC
        yCoord = yC
        x = xPos
        y = yPos
        isActive = true
        letraPrev = ""
    }
    
}
