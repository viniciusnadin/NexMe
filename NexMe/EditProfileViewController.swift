//
//  EditProfileViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift

class EditProfileViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: EditProfileViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var informationsView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK :- Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
        self.viewModel.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
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
    
    func configureBinds() {
        self.viewModel.name.asObservable()
            .bind(to: nameLabel.rx.text)
            .addDisposableTo(viewModel.disposeBag)
        
        self.viewModel.email.asObservable()
            .bind(to: emailLabel.rx.text)
            .addDisposableTo(viewModel.disposeBag)
        
        self.viewModel.avatarImageURL.asObservable().subscribe(onNext: { avatar in
            self.avatar.kf.setImage(with: self.viewModel.avatarImageURL.value)
        }).addDisposableTo(viewModel.disposeBag)

    }

}
