//
//  PontuacaoViewController.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 15/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class PontuacaoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var recebe : Int = 0
    var pontos = [0, 1, 2];
    var pontos2 = [100, 200, 1000]
    @IBOutlet weak var tv: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self;
        tv.dataSource = self;
        pontos[0] = recebe;
        
        var nib : UINib = UINib(nibName: "PontuacaoTableViewCell", bundle: nil);
        tv.registerNib(nib, forCellReuseIdentifier: "PontCell");
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var celula = tv.dequeueReusableCellWithIdentifier("PontCell", forIndexPath: indexPath) as! PontuacaoTableViewCell;
        celula.nome.text! = "ayy lmao";
        celula.pontos.text = "\(pontos[indexPath.row])";
        celula.foto.image = UIImage(named: "fotoPadrao");
//        return celula;
        //UITableViewCell(style: <#UITableViewCellStyle#>, reuseIdentifier: <#String?#>)
        return celula;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pontos.count;
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
