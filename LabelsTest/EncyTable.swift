//
//  EncyTable.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 22/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import Foundation
import UIKit

class EncyTable: UITableViewController {
    var categorias = ["Frutas", "Sei la", "Fantas"];
    var palavrasTeste = ["Bananas e Maçãs", "Ayy lmao", "Não é Sukita"];
    
    var details: EncyDetails? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers;
            self.details = controllers[controllers.count-1].topViewController as? EncyDetails;
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell;
        cell.textLabel!.text = categorias[indexPath.row];
        
        return cell;
    }
    
    //8:00
    
    //MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let controller = segue.destinationViewController as! EncyDetails;
                controller.q = palavrasTeste[indexPath.row];
            }
        }
    }
}