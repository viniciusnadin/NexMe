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
import PopupDialog

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: SignInViewModel
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mailIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.viewModel.router.successSignUp {
            self.viewModel.router.successSignUp = false
            self.viewModel.router.presentMain()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        self.configureBinds()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        let tapOnView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
        self.mailIcon.image = UIImage.fontAwesomeIcon(code: "fa-user-o", textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        self.passwordIcon.image = UIImage.fontAwesomeIcon(code: "fa-lock", textColor: UIColor.white, size: CGSize(width: 30, height: 30))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    func configureBinds() {
        signInButton.rx.tap.subscribe(onNext: {
            self.dismissKeyboard()
            self.viewModel.tryToSignIn()
        }).addDisposableTo(viewModel.disposeBag)
        
        signUpButton.rx.tap.subscribe(onNext: {
            self.viewModel.signUp()
        }).addDisposableTo(viewModel.disposeBag)
        
        self.viewModel.successLogin.asObservable().bind { (verify) in
            if verify{self.viewModel.router.presentMain()}
            }.addDisposableTo(self.viewModel.disposeBag)
        
        emailTextField.rx.text.orEmpty.map({$0})
            .bind(to: viewModel.email)
            .addDisposableTo(viewModel.disposeBag)
        
        viewModel.loading.asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .addDisposableTo(viewModel.disposeBag)
        
        viewModel.loading.asObservable().map(negate)
            .bind(to:signInButton.rx.isEnabled)
            .addDisposableTo(viewModel.disposeBag)
        
        passwordTextField.rx.text.orEmpty.map({$0})
            .bind(to: viewModel.password)
            .addDisposableTo(viewModel.disposeBag)
        
        viewModel.errorMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                PopUpDialog.present(title: "Ops!", message: message, viewController: self)
            }).addDisposableTo(viewModel.disposeBag)
        
        viewModel.successMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                let pop2 = PopupDialog(title: "Bem vindo!", message: message, image: nil, buttonAlignment: UILayoutConstraintAxis.horizontal, transitionStyle: PopupDialogTransitionStyle.fadeIn, gestureDismissal: true, completion: {
                    self.viewModel.successLogin.value = true
                })
                self.present(pop2, animated: true, completion: nil)
            }).addDisposableTo(viewModel.disposeBag)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }else if textField == self.passwordTextField {
            self.dismissKeyboard()
            self.viewModel.tryToSignIn()
        }
        return false
    }
}





