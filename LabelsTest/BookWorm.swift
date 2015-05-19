//
//  BookWorm.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/19/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class Bookworm:GameScene {
    
    //array que guarda as tiles das letras selecionadas no momento
    var letrasSelecionadas:NSMutableArray!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.setupScene()
        
        letrasSelecionadas = NSMutableArray()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let locationGrid = touch.locationInNode(self.tabuleiro)
            
            if let body = physicsWorld.bodyAtPoint(location) {
                if body.node!.name == "letra" {
                    //let nodinho = body.node as! LetraNode
                    //let letrinha:String = nodinho.letra
                    
                    //buscando a letra pela posição do toque na grid, e nao no bodyAtPoint
                    if let tilezinha = self.tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y){
                        if tilezinha.isActive == true {
                            //tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)!.content?.alpha = 0.5
                            tilezinha.content?.alpha = 0.5
                            tilezinha.isActive = false
                            let nodinho = tilezinha.content
                            letrasSelecionadas.addObject(tilezinha)
                            let letrinha:String = nodinho!.letra
                            println(letrinha)
                            self.curString = "\(curString)\(letrinha)"
                            self.myLabel.text = curString
                            self.validaPalavra(myLabel.text)
                            self.myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
                            myLabel.physicsBody?.dynamic = false
                            
                            for letra in self.tabuleiro.getOrthoNeighbors(tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)!) {
                                //letra.alpha = 0.5
                            }
                        }
                    }
                    
                    
                }
                
                if body.node!.name == "refresh" {
                    self.apagar()
                }
            }
        }
    }
    
    override func validaPalavra(palavra: String) {
        for resposta in palavrasTeste {
            if resposta == palavra {
                score += Int(timeLeft)*10 * count(palavra);
                totalScore.text = "\(score)";
                self.popScore("\(Int(timeLeft)*10 * count(palavra))")
                curString = ""
                for tile in letrasSelecionadas {
                    self.acertaTile(tile as! Tile)
                }
                letrasSelecionadas = NSMutableArray()
            }
        }
    }
    
    func acertaTile(tile:Tile){
        tile.content?.alpha = 0.1
    }
    
    func apagar(){
        curString = ""
        for tile in letrasSelecionadas {
            //jesus
            let tileAux = tile as! Tile
            tileAux.isActive = true
            tile.content!!.alpha = 1.0
        }
        self.myLabel.text = ""
        letrasSelecionadas = NSMutableArray()
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        //Controle do timer
//        if((currentTime - lastUpdate) > 0.5){
//            if(timeLeft > 0){
//                lastUpdate = currentTime;
//                timeLeft -= 0.5;
//                timeLabel.text = "\(Int(timeLeft))";
//            } else {
//                self.gameOver();
//            }
//        }
        
    }

    
}
