//
//  BookWorm.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/19/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class Bookworm:GameScene {
    
    var shuffleButton:SKSpriteNode!
    
    //array que guarda as tiles das letras selecionadas no momento
    var letrasSelecionadas:NSMutableArray!
    
    var letrasVizinhas:NSMutableArray!
    
    //mantem em memoria o proximo tabuleiro, para nao ter que gerar na hora que clicar no botao
    var proximoTabuleiro:Tabuleiro!
    
    override func prep(){
        self.setupScene(8)
        self.setupLex()
    }
        
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
//        self.setupScene(8)
//        
//        self.setupLex()
        
        self.proximoTabuleiro = Tabuleiro(x: self.cols, y: self.rows, tamanho: self.tam)
        self.proximoTabuleiro.position = CGPointMake(10000, self.size.height * 0.18)
        self.addChild(proximoTabuleiro)
        
        self.preparaProximo()
        
        shuffleButton = SKSpriteNode(imageNamed: "apple")
        shuffleButton.name = "shuffle"
        shuffleButton.size = CGSizeMake(80, 80)
        shuffleButton.physicsBody = SKPhysicsBody(rectangleOfSize: reButton.size)
        shuffleButton.physicsBody?.dynamic = false
        shuffleButton.position = CGPointMake(self.size.width - 50, 50)
        
        self.addChild(shuffleButton)
        
        letrasVizinhas = NSMutableArray()
        letrasSelecionadas = NSMutableArray()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if(!perdeu && !venceu){
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
                    if body.node!.name == "shuffle" {
                        self.trocaLetras()
                    }
                }
            }
        }
    }
    
    override func validaPalavra(palavra: String) {
        for resposta in palavrasTeste {
            if resposta.uppercaseString == palavra {
                score += Int(timeLeft)*10 * count(palavra) * possibleScore;
                totalScore.text = "\(score)";
                self.popScore("\(Int(timeLeft)*10 * count(palavra) * possibleScore)")
                possibleScore = 0;
                curString = ""
                for tile in letrasSelecionadas {
                    self.acertaTile(tile as! Tile)
                }
                self.player.fire(self.enemy!, tela: self.telaNode)
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
        for vl in scienceVector{
            if(vl.letra == letrinha){
                possibleScore += vl.valor;//Adiciona o valor da letra no possivel valor.
                println(possibleScore);
                break;
            }
        }
        
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
    
    //rubens: 5400
    //ayylmao: 8400
    
    func acertaTile(tile:Tile){
        tile.content?.alpha = 0.1
    }
    
    func apagar(){
        curString = ""
        possibleScore = 0;
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
    
    override func trocaLetras() {
        for i in 0...self.tabuleiro.grid.columns-1 {
            for j in 0...self.tabuleiro.grid.rows-1 {
                let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: proximoTabuleiro.tileForPos(i, y: j)?.content!.letra as String!, tam: self.tam)
                tabuleiro.updateLetraNode(i, y: j, letra: letraAux)
            }
        }
        self.preparaProximo()
    }
    
    func preparaProximo(){
        
        for i in 0...self.tabuleiro.grid.columns-1 {
            for j in 0...self.tabuleiro.grid.rows-1 {
                if var tile = proximoTabuleiro.tileForPos(i, y: j) {
                    tile.content?.removeFromParent()
                    tile.letraPrev = ""
                }
            }
        }
        self.encheProx(self.seedar(8))
    }
    
    
    //recebe um array com as palavras que devem ser inseridas na grid; as suas letras consecutivas devem estar em tiles vizinhas
    override func encheLetras(seed:NSMutableArray) {

        self.colocaPalavra(seed, noTabuleiro:self.tabuleiro)
        for i in 0...self.tabuleiro.grid.columns-1 {
            for j in 0...self.tabuleiro.grid.rows-1 {
                if (tabuleiro.tileForPos(i, y: j)?.letraPrev == ""){
                    
                    let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: self.randomLetra(), tam: self.tam)
                    tabuleiro.addLetraNode(i, y: j, letra: letraAux)
                    
                }
            }
        }
    }
    
    func encheProx(seed:NSMutableArray) {
        self.colocaPalavra(seed, noTabuleiro: self.proximoTabuleiro)
        for i in 0...self.proximoTabuleiro.grid.columns-1 {
            for j in 0...self.proximoTabuleiro.grid.rows-1 {
                if (proximoTabuleiro.tileForPos(i, y: j)?.letraPrev == ""){
                    
                    let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: self.randomLetra(), tam: self.tam)
                    proximoTabuleiro.addLetraNode(i, y: j, letra: letraAux)
                    
                }
            }
        }
    }
    
    func colocaPalavra(palavras:NSMutableArray, noTabuleiro:Tabuleiro){
        for indicePalavra in 0...palavras.count-1{
            var flagPalavra = false
            var tries = 80
            //posicao da primeira letra da palavra
            do{
                
                let rC = arc4random_uniform(UInt32(noTabuleiro.grid.columns-1))
                let rR = arc4random_uniform(UInt32(noTabuleiro.grid.rows-1))
                
                let startTile = noTabuleiro.tileForPos(Int(rC) , y: Int(rR))!
                
                if startTile.letraPrev == "" {
                    flagPalavra =  self.colocaX(palavras.objectAtIndex(indicePalavra) as! String, letra: 0, neighbors: noTabuleiro.getOrthoNeighborTiles(startTile), noTabuleiro: noTabuleiro)
            
                }
                
                if tries < 1 {
                    //volta
                    //abort()
                    return
                }
                tries--
            }while(!flagPalavra)
        }
        
        
    }
    
    func colocaX(palavra: String, letra: Int, neighbors:Array<Tile>, noTabuleiro:Tabuleiro) -> Bool {
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
                if(colocaX(palavra, letra: letra + 1, neighbors: noTabuleiro.getOrthoNeighborTiles(tile), noTabuleiro:noTabuleiro)){//Continua a recursão
                    let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: String(palavraArr[letra]).uppercaseString, tam: self.tam)
                    noTabuleiro.addLetraNode(tile.x, y: tile.y, letra: letraAux)
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
    
    
}



