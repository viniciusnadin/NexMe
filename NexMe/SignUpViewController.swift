//
//  SignUpViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 07/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Pastel

class SignUpViewController: UIViewController {
    
    let viewModel: SignUpViewModel
    
    // MARK :- Outlets
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    init(viewModel: SignUpViewModel) {
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
    
    deinit {
        print("ASDUFAGYSDFGYAGYSDGYASDYGF")
    }
    
    override func viewWillLayoutSubviews() {
        self.setPastelView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func configureBinds() {
        self.signInButton.rx.tap.subscribe(onNext: {
            self.viewModel.signIn()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        viewModel.loading.asObservable().map(negate)
            .bind(to:signUpButton.rx.isEnabled)
            .addDisposableTo(viewModel.disposeBag)
        
        viewModel.loading.asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .addDisposableTo(viewModel.disposeBag)
        
        signUpButton.rx.tap.subscribe(onNext: {
            self.viewModel.tryToSignUp()
        }).addDisposableTo(viewModel.disposeBag)
        
        self.nameTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.name)
        .addDisposableTo(self.viewModel.disposeBag)
        
        emailTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.email)
        .addDisposableTo(self.viewModel.disposeBag)
        
        passwordTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.password)
        .addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.errorMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                PopUpDialog.present(title: "Ops!", message: message, viewController: self)
        }).addDisposableTo(viewModel.disposeBag)
    }

}
