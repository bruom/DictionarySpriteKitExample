//
//  GameViewController.swift
//  LabelsTest
//
//  Created by Rubens Gondek on 5/14/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    var gameType:Int = 0 //0 Grid, 1 Scramble
    var skView:SKView!
    var inGame:Bool! = false
    var instructions:UILabel!
    
    lazy var scene:GameScene = {
        var aux:GameScene
        if self.gameType == 0{
            aux = Bookworm()
        }
        else if self.gameType == 1{
            aux = Scramble()
        } else {
            aux = Scramble();
        }
        aux.vc = self
        return aux
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = SKView()
        skView.frame.size = self.view.frame.size
        self.view.addSubview(skView)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        //colocar instruções aqui
        instructions = UILabel(frame: CGRectMake(300, 300, 300, 30))
        instructions.text = "LOADING . . ."
        self.view.addSubview(instructions)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
            self.scene.size = self.view.frame.size
            self.scene.prep()
            self.skView.ignoresSiblingOrder = true
            self.scene.scaleMode = .AspectFill
        })
        
        
//        let scene:Scramble = Scramble()
        
        

//        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
//            scene.vc = self
//            // Configure the view.
//            let skView = self.view as! SKView
//            skView.showsFPS = false
//            skView.showsNodeCount = false
//            skView.showsPhysics = true
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//            
//            skView.presentScene(scene)
//        }
    }


    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !(inGame){
            inGame = true
            self.instructions.removeFromSuperview()
            self.skView.presentScene(self.scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        skView.presentScene(nil);
        var pontuacao = segue.destinationViewController as! PontuacaoViewController;
        pontuacao.recebe = sender as! Int;
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
