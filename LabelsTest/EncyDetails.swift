//
//  EncyDetail.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 22/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import Foundation
import UIKit

class EncyDetails: UIViewController {

    @IBOutlet weak var teste: UILabel!
    var q : String?
//    var detailItem: AnyObject? {
//        didSet {
//            self.configureView()
//        }
//    }
    
//    func configureView(){
//        if let detail: AnyObject = detailItem {
//            if let oTeste
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue;
        UIDevice.currentDevice().setValue(value, forKey: "orientation");
        
        
        teste.text = q;
        //self.configureView();
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
}