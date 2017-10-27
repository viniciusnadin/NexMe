//
//  ProfileViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 11/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import FontAwesome_swift
import PopupDialog

class ProfileViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: ProfileViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    // MARK :- Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
        self.viewModel.viewDidLoad()
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
    
    // MARK :- Methods
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.changePasswordButton.rx.tap.subscribe(onNext: {
            self.viewModel.passwordReset()
            let pop = PopupDialog(title: "Redifinição da senha", message: "Enviamos em seu email instruções para redefinir sua senha :)")
            self.present(pop, animated: true, completion: nil)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.name.asObservable()
            .bind(to: nameLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        self.viewModel.email.asObservable()
            .bind(to: emailLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        self.viewModel.avatarImageURL.asObservable().subscribe({ avatar in
            self.avatar.kf.setImage(with: self.viewModel.avatarImageURL.value, placeholder: #imageLiteral(resourceName: "userProfile"), options: nil, progressBlock: nil, completionHandler: nil)
        }).disposed(by: viewModel.disposeBag)
        
        
    }

}
