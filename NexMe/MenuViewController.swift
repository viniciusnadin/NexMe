//
//  MenuViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PopupDialog
import Kingfisher
import SlideMenuControllerSwift

class MenuViewController: UIViewController {
    let imagePicker = ImagePicker()
    let viewModel: MenuViewModel
    
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var closeMenuButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        self.viewModel.viewDidLoad()
        super.init(nibName: String("MenuViewController"), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
    }
    
    func configureBinds() {
        self.eventsButton.rx.tap.subscribe(onNext: {
            self.viewModel.presentEvents()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.signOutButton.rx.tap.subscribe(onNext: {
            let pop2 = PopupDialog(title: "Até logo!", message: "Aguardamos o seu retorno :)", image: nil, buttonAlignment: UILayoutConstraintAxis.horizontal, transitionStyle: PopupDialogTransitionStyle.fadeIn, gestureDismissal: true, completion: {
                self.viewModel.successFullSignOut.value = true
            })
            self.present(pop2, animated: true, completion: nil)
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.profileButton.rx.tap.subscribe(onNext: {
            self.viewModel.presentProfile()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.usersButton.rx.tap.subscribe(onNext: {
            self.viewModel.presentUsersSearch()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.closeMenuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.closeLeft()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.avatarImageURL.asObservable().subscribe(onNext: { avatar in
            self.avatar.kf.setImage(with: self.viewModel.avatarImageURL.value)
        }).addDisposableTo(viewModel.disposeBag)
        
        self.viewModel.successFullSignOut.asObservable().bind { (verify) in
            if verify {
                self.viewModel.signOut()
            }
        }.addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.name.asObservable()
            .bind(to: nameLabel.rx.text)
            .addDisposableTo(self.viewModel.disposeBag)
    }
    
    @IBAction func editAvatarButtonTouched(_ sender: UIButton) {
        imagePicker.pickImageFromViewController(viewController: self) { result in
            do {
                let image = try result.getValue()
                self.avatar.image = image
                self.viewModel.uploadImage(image: image)
            } catch {
                print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
