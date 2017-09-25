//
//  SignInViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 24/08/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Pastel

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: SignInViewModel
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
    }
    
    override func viewWillLayoutSubviews() {
        self.setPastelView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    func configureBinds() {
        signInButton.rx.tap.subscribe(onNext: {
            self.viewModel.tryToSignIn()
        }).addDisposableTo(viewModel.disposeBag)
        
        signUpButton.rx.tap.subscribe(onNext: {
            self.viewModel.signUp()
        }).addDisposableTo(viewModel.disposeBag)
        
        emailTextField.rx.text.orEmpty.map({!$0.isEmpty})
            .bind(to:signInButton.rx.isEnabled)
            .addDisposableTo(viewModel.disposeBag)
        
        emailTextField.rx.text.orEmpty.map({$0})
            .bind(to: viewModel.email)
            .addDisposableTo(viewModel.disposeBag)
        
        passwordTextField.rx.text.orEmpty.map({$0})
            .bind(to: viewModel.password)
            .addDisposableTo(viewModel.disposeBag)
        
        viewModel.errorMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                PopUpDialog.present(title: "Ops!", message: message, viewController: self)
            }).addDisposableTo(viewModel.disposeBag)
    }
    
    func setPastelView() {
        let pastelView = PastelView(frame: self.view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.setColors([UIColor(red: 27/255, green: 206/255, blue: 223/255, alpha: 1.0), UIColor(red: 91/255, green: 36/255, blue: 122/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    

}
