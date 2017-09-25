//
//  ProfileViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 11/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift

class ProfileViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: ProfileViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    // MARK :- Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
        self.configureLayouts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).addDisposableTo(self.viewModel.disposeBag)
    }
    
    func configureLayouts() {
        self.editButton.layer.borderWidth = 1
        self.editButton.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        self.editButton.layer.cornerRadius = 5
        
        self.avatar.layer.cornerRadius = 30
        self.avatar.translatesAutoresizingMaskIntoConstraints = false
        self.avatar.clipsToBounds = true
        self.avatar.contentMode = .scaleToFill
    }

}