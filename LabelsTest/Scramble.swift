//
//  Scramble.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/18/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import SpriteKit

class Scramble:SKScene {
    var lastUpdate : NSTimeInterval = 0;
    var curString:String = ""
    var myLabel:SKLabelNode!
    var tam:CGFloat = CGFloat(80)
    var prompt:SKLabelNode!
    
    var timeLabel : SKLabelNode!;
    var timeLeft = 60.00
    
    var target:String!
    
    
    var scienceVector = ["A", "A", "A", "A", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var palavrasTeste = ["English", "Potato", "Pirate", "Lexicus", "Dog", "Car", "Cheese"]
    
    var tabuleiro:Tabuleiro!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.size = view.frame.size
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.name = "label"
        myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
        myLabel.physicsBody?.dynamic = false
        myLabel.text = curString
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:100);
        
        self.addChild(myLabel)
        
        prompt = SKLabelNode(fontNamed: "Helvetica")
        prompt.position = CGPointMake(self.size.width/2, self.size.height * 0.7)
        
        self.addChild(prompt)
        
        tabuleiro = Tabuleiro(x: 5, y: 2, tamanho: tam)
        tabuleiro.position = CGPointMake(self.size.width/2 - tam*5/2, self.size.height * 0.18)
        self.addChild(tabuleiro)
        
        self.encheLetras(seedar())
        
        timeLabel = SKLabelNode(fontNamed: "Comic Sans")//AYY
        timeLabel.position = CGPointMake(self.frame.size.width * 0.1, self.frame.size.height * 0.9);
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let locationGrid = touch.locationInNode(self.tabuleiro)
            
            if let body = physicsWorld.bodyAtPoint(location) {
                if body.node!.name == "letra" {
                    
                    //buscando a letra pela posição do toque na grid, e nao no bodyAtPoint
                    if let tilezinha = self.tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y){
                        tabuleiro.tileForCoord(locationGrid.x, y: locationGrid.y)!.content?.alpha = 0.5
                        let nodinho = tilezinha.content
                        let letrinha:String = nodinho!.letra
                        self.validaLetra(letrinha)
                        self.curString = "\(curString)\(letrinha)"
                        self.myLabel.text = curString
                        self.myLabel.physicsBody = SKPhysicsBody(rectangleOfSize: myLabel.frame.size)
                        myLabel.physicsBody?.dynamic = false
                    }
                    
                    
                }
                if body.node!.name == "label" {
                    let nodelinho: SKLabelNode = body.node! as! SKLabelNode
                    //consultarDicionario(nodelinho.text)
                    validaPalavra(nodelinho.text)
                    curString = ""
                }
            }
            
        }
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
        if palavra == target {
            self.popScore("+8001!")
        }
    }
    
    func validaLetra(letra: String) {
        let auxPalavra = "\(curString)\(letra)"
        if target == auxPalavra {
            popScore("ACERTOU!")
        }
        if !target.hasPrefix(auxPalavra){
            popScore("ERROU!")
        }
        
    }
    
    func seedar() -> NSMutableArray{
        
        //define as palavras para seedar
        var letrasSeedadas:NSMutableArray = NSMutableArray()
        let rand = arc4random_uniform(UInt32(palavrasTeste.count-1))
        target = palavrasTeste[Int(rand)]
        self.prompt.text = palavrasTeste[Int(rand)]
        
        
        //garante que as letras apareçam na tela
        let letras = Array(target)
        for letra in letras {
            let letraStr = "\(letra)"
            letrasSeedadas.addObject(letraStr)
        }
        
        return letrasSeedadas
        
    }
    
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
        for i in 0...seed.count-1 {
            let letraAux:LetraNode = LetraNode(texture: SKTexture(imageNamed: "square"), letra: seed.objectAtIndex(i) as! String, tam: self.tam)
            letrasFinal.append(letraAux)
        }
        for i in seed.count...self.tabuleiro.grid.columns*self.tabuleiro.grid.rows-1 {
            let letraAux = LetraNode(texture: SKTexture(imageNamed: "square"), letra: self.randomLetra(), tam: self.tam)
            letrasFinal.append(letraAux)
        }
        letrasFinal = letrasFinal.shuffled()
        for i in 0...self.tabuleiro.grid.columns*self.tabuleiro.grid.rows-1 {
            tabuleiro.addLetraNode(i/self.tabuleiro.grid.rows, y: i%self.tabuleiro.grid.rows, letra: letrasFinal[i])
        }
    }
    
    func randomLetra() -> String {
        let ij = arc4random_uniform(UInt32(scienceVector.count-1))
        return scienceVector[Int(ij)]
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        if((currentTime - lastUpdate) > 0.5){
            if(timeLeft > 0){
                timeLeft -= 0.5;
                timeLabel.text = "\(Int(timeLeft))";
            }
        }
        /* Called before each frame is rendered */
    }

    
}
