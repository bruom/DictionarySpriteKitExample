//
//  EncyDetail.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 22/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import Foundation
import UIKit

class EncyDetails: UIViewController, UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate {

    @IBOutlet weak var teste: UILabel!
    var q : String?
    @IBOutlet weak var detailsTV: UITableView!
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
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible;

        let value = UIInterfaceOrientation.LandscapeLeft.rawValue;
        UIDevice.currentDevice().setValue(value, forKey: "orientation");
        
        
        teste.text = q;
        
        detailsTV.delegate = self;
        detailsTV.dataSource = self;
        //self.configureView();
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var celula = detailsTV.dequeueReusableCellWithIdentifier("EncyDetCell") as! EncyDetailsCell;
        //celula.backgroundColor = UIColor.yellowColor();
        celula.palavra.text = q;
        celula.traducao.text = q;
        celula.dica.text = q;
        return celula;
    }
    
    
    
//    override func supportedInterfaceOrientations() -> Int {
//        return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
//    }
//    
//    override func shouldAutorotate() -> Bool {
//        return false;
//    }
    
//    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
//        return false;
//
//    }
//    - (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
//        return NO;
//    }
}