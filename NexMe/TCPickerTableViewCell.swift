//
//  TCPickerTableViewCell.swift
//  TCPickerView
//
//  Created by Taras Chernyshenko on 9/4/17.
//  Copyright © 2017 Taras Chernyshenko. All rights reserved.
//

import UIKit

class TCPickerTableViewCell: UITableViewCell {
    
    struct ViewModel {
        let title: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            self.titleLabel?.text = self.viewModel?.title ?? ""
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.text = self.viewModel?.title ?? ""
    }
    
    private var titleLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    fileprivate func initialize() {
        self.titleLabel = UILabel(frame: CGRect.zero)
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        guard let titleLabel = self.titleLabel else{
            return
        }
        
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .leading, relatedBy: .equal, toItem: self,
            attribute: .leading, multiplier: 1.0, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .top, relatedBy: .equal, toItem: self,
            attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .bottom, relatedBy: .equal, toItem: self,
            attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .trailing, relatedBy: .equal, toItem: imageView,
            attribute: .leading, multiplier: 1.0, constant: 8))
    }
}
