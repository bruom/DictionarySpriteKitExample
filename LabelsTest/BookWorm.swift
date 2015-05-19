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
    
    override func seedar(num: Int) -> NSMutableArray{
        
        //define as palavras para seedar
        var cont = num
        var palavrasSeedadas:NSMutableArray = NSMutableArray()
        while cont >= 0 {
            let rand = arc4random_uniform(UInt32(palavrasTeste.count-1))
            if (!palavrasSeedadas.containsObject(palavrasTeste[Int(rand)])) {
                palavrasSeedadas.addObject(palavrasTeste[Int(rand)])
                println(palavrasTeste[Int(rand)])
                cont--
            }
        }
        return palavrasSeedadas
    }
    
    
    //recebe um array com as palavras que devem ser inseridas na grid; as suas letras consecutivas devem estar em tiles vizinhas
    override func encheLetras(seed:NSMutableArray) {
        //tenta inserir cada palavra
        //var matriz = Matriz<String>(columns: cols, rows: rows)
        for palavra in seed {
            self.colocaPalavra(palavra as! String)
        }
    }
    
    func colocaPalavra(palavra:String){
        let letras = Array(palavra)
        
        //posicao da primeira letra da palavra
        let rC = arc4random_uniform(UInt32(self.tabuleiro.grid.columns-1))
        let rR = arc4random_uniform(UInt32(self.tabuleiro.grid.rows-1))
        
        let startTile = self.tabuleiro.tileForPos(Int(rC) , y: Int(rR))!
        
        if startTile.letraPrev == "" {
            for letra in letras {
                self.colocaLetra(letra as! String, neighbors: self.tabuleiro.getOrthoNeighborTiles(startTile))
            }
        }
        
        
    }
    
    func colocaLetra(letra:String, neighbors:NSMutableArray) -> Bool{
        let tile = neighbors.firstObject as! Tile
        if neighbors.count == 0 {
            return false
        }
        if tile.letraPrev == "" {
            tile.letraPrev = letra
            return true
        }
        else{
            neighbors.removeObjectAtIndex(0)
            return colocaLetra(letra, neighbors: neighbors)
        }
        //return true
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
