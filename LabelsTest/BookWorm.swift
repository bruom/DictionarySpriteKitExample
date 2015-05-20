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
    
    var letrasVizinhas:NSMutableArray!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.setupScene(9)
        
        letrasVizinhas = NSMutableArray()
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
                        if tilezinha.isActive == true{
                            
                            if self.curString == ""{
                                //tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)!.content?.alpha = 0.5
                                self.eventoToque(tilezinha, locationGrid: locationGrid)
                            }
                            else {
                                if letrasVizinhas.containsObject(tilezinha){
                                    self.eventoToque(tilezinha, locationGrid: locationGrid)
                                }
                                else{
                                    self.apagar()
                                    self.eventoToque(tilezinha, locationGrid: locationGrid)
                                }
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
            if resposta.uppercaseString == palavra {
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
    
    func eventoToque(tile:Tile, locationGrid:CGPoint){
        tile.content?.alpha = 0.5
        tile.isActive = false
        let node = tile.content
        letrasSelecionadas.addObject(tile)
        let letrinha:String = node!.letra
        println(letrinha)
        self.curString = "\(curString)\(letrinha)"
        self.myLabel.text = curString
        self.validaPalavra(myLabel.text)
        self.myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
        myLabel.physicsBody?.dynamic = false
        
        for letra in self.tabuleiro.getOrthoNeighbors(tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)!) {
            //letra.alpha = 0.5
        }
        
        letrasVizinhas = NSMutableArray()
        for tileVizinha in self.tabuleiro.getOrthoNeighborTiles(tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)!) {
            letrasVizinhas.addObject(tileVizinha)
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
            let rand = arc4random_uniform(UInt32(palavrasTeste.count))
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
//        for palavra in seed {
//            self.colocaPalavra(palavra as! String)
//            break;
//        }
        self.colocaPalavra(seed)
        for i in 0...self.tabuleiro.grid.columns-1 {
            for j in 0...self.tabuleiro.grid.rows-1 {
                if (tabuleiro.tileForPos(i, y: j)?.letraPrev == ""){
                    
                let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: self.randomLetra(), tam: self.tam)
                tabuleiro.addLetraNode(i, y: j, letra: letraAux)
                    
                }
            }
        }
    }
    
    func colocaPalavra(palavras:NSMutableArray){
        for indicePalavra in 0...palavras.count-1{
            var flagPalavra = false
            var tries = 80
            //posicao da primeira letra da palavra
            do{
                
                let rC = arc4random_uniform(UInt32(self.tabuleiro.grid.columns-1))
                let rR = arc4random_uniform(UInt32(self.tabuleiro.grid.rows-1))
                
                let startTile = self.tabuleiro.tileForPos(Int(rC) , y: Int(rR))!
                
                if startTile.letraPrev == "" {
                    flagPalavra =  self.colocaX(palavras.objectAtIndex(indicePalavra) as! String, letra: 0, neighbors: self.tabuleiro.getOrthoNeighborTiles(startTile))
            
                }
                
                if tries < 1 {
                    //volta
                    abort()
                }
                tries--
            }while(!flagPalavra)
        }
        
        
    }
    
//    func colocaPalavra(palavra:String){
//        let letras = Array(palavra)
//        
//        //posicao da primeira letra da palavra
//        let rC = arc4random_uniform(UInt32(self.tabuleiro.grid.columns-1))
//        let rR = arc4random_uniform(UInt32(self.tabuleiro.grid.rows-1))
//        
//        let startTile = self.tabuleiro.tileForPos(Int(rC) , y: Int(rR))!
//        
//        if startTile.letraPrev == "" {
//            for letra in letras {
//                let continua = self.colocaLetra(letra as! String, neighbors: NSMutableArray(array: self.tabuleiro.getOrthoNeighborTiles(startTile)))
//                if(!continua){
//                    
//                }
//            }
//        } else {
//            colocaPalavra(palavra);
//        }
//        
//        
//    }
    
    func colocaX(palavra: String, letra: Int, neighbors:Array<Tile>) -> Bool {
        var palavraArr = Array(palavra);
        
        if(letra >= palavraArr.count){
            return true;//Se toda a palavra foi inserida com sucesso, acaba o backtracking
        }
        println(neighbors.count);
        var shufNeighbors = neighbors.shuffled()
        for n in shufNeighbors {//Percorrendo as tiles vizinhas
            
            let tile = n;
            println(tile.x);
            println(tile.y);
            if(tile.letraPrev == ""){ //Verifica se está ocupada
                tile.letraPrev = String(palavraArr[letra])// as! String;//Seta a tile como ocupada
                if(colocaX(palavra, letra: letra + 1, neighbors: self.tabuleiro.getOrthoNeighborTiles(tile))){//Continua a recursão
                    let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: String(palavraArr[letra]).uppercaseString, tam: self.tam)
                    self.tabuleiro.addLetraNode(tile.x, y: tile.y, letra: letraAux)
                    println(palavraArr[letra]);
                    return true;//Se toda ele conseguiu inserir o resto das palavras, retorna true;
                } else {
                    tile.letraPrev = "";//Se deu ruim, desocupa o tile.
                    
                }
                return false
            }//if
        }//for
        
        return false
        

    }
    
    func colocaLetra(letra:String, neighbors:NSMutableArray) -> Bool{
        //randomizar neighbors
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



