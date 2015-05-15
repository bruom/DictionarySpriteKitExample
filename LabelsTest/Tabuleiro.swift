//
//  Tabuleiro.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/15/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class Tabuleiro: SKNode {
    
    var grid:Matriz<Tile>!
    var tam:CGFloat!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(x:Int, y:Int, tamanho:CGFloat) {
        super.init()
        grid = Matriz(columns: x, rows: y)
        tam = tamanho
        for i in 0...x-1 {
            for j in 0...y-1 {
                grid[i,j] = Tile(xC: CGFloat(i)*tam, yC: CGFloat(j)*tam, xPos: i, yPos: j)
                grid[i,j]?.content = nil
            }
        }
        
    }
    
    func coordForTile(tile:Tile) -> CGPoint {
        return CGPointMake(tile.xCoord, tile.yCoord)
    }
    
    func coordForTile(x:Int, y:Int) -> (CGPoint, Bool) {
        
        if x < 0 || x >= grid.columns || y < 0 || y >= grid.rows {
            return (CGPointZero, false)
        }
        
        return (CGPointMake(CGFloat(x)*tam, CGFloat(y)*tam), true)
    }
    
    func tileForPos(x:Int, y:Int) -> Tile?{
        if x < 0 || x >= grid.columns || y < 0 || y >= grid.rows {
            return (nil)
        }
        return self.grid[x,y]!
    }
    
    func tileForCoord(x:CGFloat, y:CGFloat) -> Tile! {
        var xPos = Int(x/tam)
        var yPos = Int(y/tam)
        println("\(xPos) \(yPos)")
        if xPos < 0 || yPos < 0 {
            return nil
        }
        return self.grid[xPos,yPos]!
    }
    
    func getNeighbors(tile:Tile) -> Array<LetraNode> {
        var nodes = Array<LetraNode>()
        var x = tile.x
        var y = tile.y
        return getNeighbors(x, y: y)
    }
    
    func getNeighbors(x:Int, y:Int) -> Array<LetraNode> {
        var nodes = Array<LetraNode>()
        
        for i in -1...1 {   //percorre as tiles ao redor
            for j in -1...1 {
                if i != 0 || j != 0 {   //exceto a própria tile
                    if let tile = tileForPos(x + i, y: y + j){ //se houver tal tile, isto é, não for borda
                        if let letra:LetraNode = tile.content { //se a tile tiver uma letra nela
                            
                            nodes.append(letra)
                            
                        }
                    }
                }
            }
        }
            
        
        return nodes
    }
    
    func addLetraNode(x:Int, y:Int, letra:LetraNode) {
        self.grid[x,y]?.content = letra
        let childNode = letra
        childNode.position = CGPointMake(self.coordForTile(x, y: y).0.x + tam/2, self.coordForTile(x, y: y).0.y + tam/2)
        childNode.size = CGSizeMake(self.tam, self.tam)
        self.addChild(childNode)
    }
    
}
