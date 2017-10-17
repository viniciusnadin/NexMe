//
//  UsersViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: UsersViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var menuButton: UIButton!
    
    
    // MARK :- Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.viewModel.searchUser()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        
    }

}

extension UsersViewController: UITableViewDelegate{
    
}


















