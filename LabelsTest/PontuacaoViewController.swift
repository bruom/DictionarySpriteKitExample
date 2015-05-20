//
//  PontuacaoViewController.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 15/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class PontuacaoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var modoJogo: UISegmentedControl!
    
    var recebe : Int = 0
    var pontos = [0, 1, 2];
    var pontos2 = [100, 200, 1000, 9, 412];
    var pontos3 = [9185, 55555, 1, 124];
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
        
        if(modoJogo.selectedSegmentIndex == 0){
            celula.nome.text! = "ayy lmao";
            celula.pontos.text = "\(pontos[indexPath.row])";
            celula.foto.image = UIImage(named: "fotoPadrao");
        } else if (modoJogo.selectedSegmentIndex == 1){
            celula.nome.text! = "Hue";
            celula.pontos.text = "\(pontos2[indexPath.row])";
            celula.foto.image = UIImage(named: "fotoPadrao");
        } else if (modoJogo.selectedSegmentIndex == 2){
            celula.nome.text! = "oaml yyA";
            celula.pontos.text = "\(pontos3[indexPath.row])";
            celula.foto.image = UIImage(named: "fotoPadrao");
        }

//        return celula;
        //UITableViewCell(style: <#UITableViewCellStyle#>, reuseIdentifier: <#String?#>)
        return celula;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(modoJogo.selectedSegmentIndex == 0){
            return pontos.count;
        } else if (modoJogo.selectedSegmentIndex == 1){
            return pontos2.count;
        } else if (modoJogo.selectedSegmentIndex == 2){
            return pontos3.count;
        } else {
            return 0;
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Segmented Control
    
    @IBAction func trocaModoJogo(sender: AnyObject) {
        self.tv.reloadData();
    }
    

}
