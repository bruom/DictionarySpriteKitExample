//
//  GameScene.swift
//  LabelsTest
//
//  Created by Rubens Gondek on 5/14/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

extension Array {
    func shuffled() -> [T] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}

class GameScene: SKScene {
    var vc : GameViewController?
    
    //Para uso do timer
    var curString:String = "" //Palavra sendo formada
    var myLabel:SKLabelNode!
    var reButton:SKSpriteNode!
    var tam:CGFloat = CGFloat(80) //Tamanho dos quadrados
    
    //Para uso do timer
    var timeLabel : SKLabelNode!;
    var timeLeft = 10.00//Tempo inicial
    var totalScore : SKLabelNode!;
    var lastUpdate : NSTimeInterval = 0;
    
    //Pontuação do jogador
    var score = 0;


    
    var scienceVector = ["A", "A", "A", "A", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var palavrasTeste = ["English", "Potato", "Pirate", "Lexicus", "Dog", "Car", "Cheese"]
    
    var tabuleiro:Tabuleiro!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.setupScene()
        
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
                        tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)!.content?.alpha = 0.5
                        let nodinho = tilezinha.content
                        let letrinha:String = nodinho!.letra
                        println(letrinha)
                        self.curString = "\(curString)\(letrinha)"
                        self.myLabel.text = curString
                        self.myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
                        myLabel.physicsBody?.dynamic = false
                    }
                    
                    //trata as letras vizinhas à selecionada
//                    let marker = SKSpriteNode(imageNamed: "Spaceship")
//                    marker.size = CGSizeMake(10, 10)
//                    marker.position = locationGrid
//                    tabuleiro.addChild(marker)
                    
                    /*for letra in self.tabuleiro.getNeighbors(tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)) {
                        //letra.alpha = 0.5
                    }*/
                    

                }
                if body.node!.name == "label" {
                    let nodelinho: SKLabelNode = body.node! as! SKLabelNode
                    //consultarDicionario(nodelinho.text)
                    validaPalavra(nodelinho.text)
                    curString = ""
                }
                if body.node!.name == "refresh" {
                    self.trocaLetras()
                }
            }
            
        }
    }
    
    func setupScene(){
        self.size = view!.frame.size
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.name = "label"
        myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
        myLabel.physicsBody?.dynamic = false
        myLabel.text = curString
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:100);
        
        self.addChild(myLabel)
        
        reButton = SKSpriteNode(imageNamed: "apple")
        reButton.name = "refresh"
        reButton.size = CGSizeMake(80, 80)
        reButton.physicsBody = SKPhysicsBody(rectangleOfSize: reButton.size)
        reButton.physicsBody?.dynamic = false
        reButton.position = CGPointMake(50, 50)
        
        self.addChild(reButton)
        
        //        for i in 1...10 {
        //            self.criaLetraTeste(randomLetra())
        //        }
        
        tabuleiro = Tabuleiro(x: 8, y: 8, tamanho: tam)
        tabuleiro.position = CGPointMake(self.size.width/2 - tam * 8 / 2, self.size.height * 0.18)
        self.addChild(tabuleiro)
        
        //self.encheLetras()
        self.encheLetras(seedar(2))
        
        timeLabel = SKLabelNode(fontNamed: "Comic Sans")//AYY
        timeLabel.position = CGPointMake(self.frame.size.width * 0.1, self.frame.size.height * 0.9);
        self.addChild(timeLabel);
        
        totalScore = SKLabelNode(fontNamed: "Comic Sans")//AYY
        totalScore.position = CGPointMake(self.frame.size.width * 0.9, self.frame.size.height * 0.9);
        totalScore.text = "0";
        self.addChild(totalScore);
    }
    
    func mudarParaBookworm(seed:NSMutableArray){
        //Verificar inicio de nova palavra pela letra maiuscula.(?)
        //Carai backtracking
        
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let locationGrid = touch.locationInNode(self.tabuleiro)
            if let tile = tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y) {
                //tile.content?.alpha = 1.0
            }
        }
    }
    
    func validaPalavra(palavra: String) {
        println(count(palavra));
        for resposta in palavrasTeste {
            if resposta == palavra {
                score += Int(timeLeft)*10 * count(palavra);
                totalScore.text = "\(score)";
                self.popScore("\(Int(timeLeft)*10 * count(palavra))")
            }
        }
    }
    
    func consultarDicionario(palavra: String){
        if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(palavra) {
            let ref = UIReferenceLibraryViewController(term: palavra)
            let pop = UIPopoverController(contentViewController: ref)
            pop.presentPopoverFromRect(CGRectMake(self.size.width/2, self.size.height - 150, 1, 1), inView: self.view!, permittedArrowDirections: UIPopoverArrowDirection.Down, animated: true)
        }
    }
    
    //Pega a determinada quantidade de palavras do vetor de palavras
    //e inicia o processo de insersão delas no tabuleiro.
    func seedar(num: Int) -> NSMutableArray{
        
        //define as palavras para seedar
        var cont = num
        var palavrasSeedadas:NSMutableArray = NSMutableArray()
        var letrasSeedadas:NSMutableArray = NSMutableArray()
        while cont >= 0 {
            let rand = arc4random_uniform(UInt32(palavrasTeste.count-1))
            if (!palavrasSeedadas.containsObject(palavrasTeste[Int(rand)])) {
                palavrasSeedadas.addObject(palavrasTeste[Int(rand)])
                println(palavrasTeste[Int(rand)])
                cont--
            }
        }
        
        //garante que as letras apareçam na tela
        for palavra in palavrasSeedadas {
            let letras = Array(palavra as! String)
            for letra in letras {
                let letraStr = "\(letra)"
                if !letrasSeedadas.containsObject(letraStr){
                    letrasSeedadas.addObject(letraStr)
                }
            }
        }
        
        return letrasSeedadas
        
    }
    
    //Animação da subida da pontuação quando acerta algo
    func popScore(score:String){
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.text = score
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height*0.2)
        scoreLabel.fontColor = UIColor.redColor()
        let fadeAction = SKAction.fadeOutWithDuration(1.5)
        let moveAction = SKAction.moveToY(self.size.height*0.8, duration: 1.5)
        self.addChild(scoreLabel)
        scoreLabel.runAction(moveAction)
        scoreLabel.runAction(fadeAction, completion: { () -> Void in
            scoreLabel.removeFromParent()
        })
    }
    
    func encheLetras(seed:NSMutableArray) {
        var letrasFinal = Array<LetraNode>()
        //Coloca as letras das palavras seedadas em letrasFinal
        for i in 0...seed.count-1 {
            let letraAux:LetraNode = LetraNode(texture: SKTexture(imageNamed: "square"), letra: seed.objectAtIndex(i) as! String, tam: self.tam)
            letrasFinal.append(letraAux)
        }
        
        //Completa o vetor letrasFinal pra se adequar ao tamanho do tabuleiro
        for i in seed.count...self.tabuleiro.grid.columns*self.tabuleiro.grid.rows-1 {
            let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: self.randomLetra(), tam: self.tam)
            letrasFinal.append(letraAux)
        }
        
        //Embaralha as letras do letrasfinal e coloca elas no tabuleiro.
        letrasFinal = letrasFinal.shuffled()
        for i in 0...self.tabuleiro.grid.columns*self.tabuleiro.grid.rows-1 {
            tabuleiro.addLetraNode(i/self.tabuleiro.grid.rows, y: i%self.tabuleiro.grid.rows, letra: letrasFinal[i])
        }
    }
    
    //Enche tabuleiro com letras aleatórias
    func encheLetras() {
        for i in 0...self.tabuleiro.grid.columns-1 {
            for j in 0...self.tabuleiro.grid.rows-1 {
                let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: self.randomLetra(), tam: self.tam)
                tabuleiro.addLetraNode(i, y: j, letra: letraAux)
            }
        }
    }
    
    //"Refaz" o tabuleiro com novas letras aleatórias
    func trocaLetras() {
        for i in 0...self.tabuleiro.grid.columns-1 {
            for j in 0...self.tabuleiro.grid.rows-1 {
                let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: self.randomLetra(), tam: self.tam)
                tabuleiro.updateLetraNode(i, y: j, letra: letraAux)
            }
        }
    }
    
    func criaLetraTeste(l:String){
        let letra = LetraNode(texture: SKTexture(imageNamed: "apple"), letra: l, tam: self.tam)
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
    
    //Pega uma letra aleatoriamente do vetor
    func randomLetra() -> String {
        let ij = arc4random_uniform(UInt32(scienceVector.count-1))
        return scienceVector[Int(ij)]
    }
    
    //Força a troca de view
    func gameOver(){
        self.vc?.performSegueWithIdentifier("gameOver", sender: score)
        
        //self.inval
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        //Controle do timer
        if((currentTime - lastUpdate) > 0.5){
            if(timeLeft > 0){
                lastUpdate = currentTime;
                timeLeft -= 0.5;
                timeLabel.text = "\(Int(timeLeft))";
            } else {
                self.gameOver();
            }
        }
        
    }
    
    
}
