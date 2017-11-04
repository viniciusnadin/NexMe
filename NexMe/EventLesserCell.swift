//
//  EventLesserCell.swift
//  NexMe
//
//  Created by Vinicius Nadin on 28/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class EventLesserCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(red: 176/255, green: 182/255, blue: 187/255, alpha: 0.5).cgColor
        self.containerView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
