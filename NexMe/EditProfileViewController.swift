//
//  EditProfileViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: EditProfileViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var informationsView: UIView!
    
    
    
    // MARK :- Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        self.informationsView.layer.masksToBounds = true
        
        self.informationsView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.informationsView.layer.shadowColor = UIColor.black.cgColor
        self.informationsView.layer.shadowOpacity = 0.2
        self.informationsView.layer.shadowRadius = 1.3
        self.informationsView.layer.shadowPath = UIBezierPath(rect: self.informationsView.bounds).cgPath
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
