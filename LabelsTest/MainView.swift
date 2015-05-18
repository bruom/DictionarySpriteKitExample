//
//  MainView.swift
//  LabelsTest
//
//  Created by Bruno Omella Mainieri on 5/18/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class MainView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func go(sender: AnyObject) {
        let gameView = self.storyboard?.instantiateViewControllerWithIdentifier("gameView") as! GameViewController
        gameView.gameType = sender.tag
        self.presentViewController(gameView, animated: true, completion: nil)
    }

}
