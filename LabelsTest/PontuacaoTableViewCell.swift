//
//  PontuacaoTableViewCell.swift
//  LabelsTest
//
//  Created by Lucas Leal Mendonça on 15/05/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class PontuacaoTableViewCell: UITableViewCell {

    @IBOutlet weak var foto: UIImageView!

    @IBOutlet weak var nome: UILabel!
    
    @IBOutlet weak var pontos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
