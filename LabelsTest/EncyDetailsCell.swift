//
//  EncyDetailsCell.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 25/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class EncyDetailsCell: UITableViewCell {

    @IBOutlet weak var palavra: UILabel!
    
    @IBOutlet weak var traducao: UILabel!
    
    @IBOutlet weak var dica: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
