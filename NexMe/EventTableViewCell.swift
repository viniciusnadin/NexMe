//
//  EventTableViewCell.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationName: UILabel!
    @IBOutlet weak var eventMonthLabel: UILabel!
    @IBOutlet weak var eventDayLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let blueColor = UIColor(red: 82/255, green: 205/255, blue: 171/255, alpha: 1.0)
        self.locationIcon.image = UIImage.fontAwesomeIcon(code: "fa-map-marker", textColor: blueColor, size: CGSize(width: 40, height: 40))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
