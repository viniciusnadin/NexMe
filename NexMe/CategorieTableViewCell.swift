//
//  CategorieTableViewCell.swift
//  NexMe
//
//  Created by Vinicius Nadin on 29/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class CategorieTableViewCell: UITableViewCell {
    @IBOutlet weak var categorieNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 4
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(red: 40/255, green: 56/255, blue: 77/255, alpha: 0.4).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
