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
    
    var content:LetraNode?
    
    var isActive:Bool!
    
    init(xC:CGFloat, yC:CGFloat, xPos:Int, yPos:Int) {
        super.init()
        xCoord = xC
        yCoord = yC
        x = xPos
        y = yPos
        isActive = true
    }
    
}
