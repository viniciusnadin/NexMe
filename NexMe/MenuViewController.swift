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

class MenuViewController: UIViewController {
    let imagePicker = ImagePicker()
    let viewModel: MenuViewModel
    
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var closeMenuButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String("MenuViewController"), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureViews()
        self.configureBinds()
    }
    
    func configureBinds() {
        self.eventsButton.rx.tap.subscribe(onNext: {
            self.viewModel.presentEvents()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.signOutButton.rx.tap.subscribe(onNext: {
            self.viewModel.signOut()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.profileButton.rx.tap.subscribe(onNext: {
            self.viewModel.presentProfile()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.name.asObservable()
            .bind(to: nameLabel.rx.text)
        .addDisposableTo(self.viewModel.disposeBag)

    }
    
    @IBAction func editAvatarButtonTouched(_ sender: UIButton) {
        imagePicker.pickImageFromViewController(viewController: self) { result in
            print(result.description)
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
