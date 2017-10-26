//
//  CardTableViewCell.swift
//  NexMe
//
//  Created by Vinicius Nadin on 18/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = contentView.frame
        let newFrame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(5, 10, 5, 10))
        contentView.frame = newFrame
    }
    
}
