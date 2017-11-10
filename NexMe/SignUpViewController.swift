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
import PopupDialog

class SignUpViewController: UIViewController {
    
    let viewModel: SignUpViewModel
    
    // MARK :- Outlets
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
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
        self.configureIcons()
        let tapOnView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
    }
    
    deinit {
        print("LOG - DEINITING SIGNUP VIEW CONTROLLER")
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func configureIcons() {
        self.nameIcon.image = UIImage.fontAwesomeIcon(code: "fa-user-o", textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        self.emailIcon.image = UIImage.fontAwesomeIcon(code: "fa-envelope", textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        self.passwordIcon.image = UIImage.fontAwesomeIcon(code: "fa-lock", textColor: UIColor.white, size: CGSize(width: 30, height: 30))
    }
    
    func configureBinds() {
        self.signInButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).disposed(by: self.viewModel.disposeBag)
        
        viewModel.loading.asObservable().map(negate)
            .bind(to:signUpButton.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.loading.asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: viewModel.disposeBag)
        
        signUpButton.rx.tap.subscribe(onNext: {
            self.dismissKeyboard()
            self.viewModel.tryToSignUp()
        }).disposed(by: viewModel.disposeBag)
        
        self.nameTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.name)
            .disposed(by: self.viewModel.disposeBag)
        
        emailTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.email)
            .disposed(by: self.viewModel.disposeBag)
        
        passwordTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.password)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.successFullSignUp.asObservable().bind { (verify) in
            if verify {
                self.viewModel.router.signInRouter.successSignUp = true
                self.viewModel.close()
            }
            }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.errorMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                PopUpDialog.present(title: "Ops!", message: message, viewController: self)
            }).disposed(by: viewModel.disposeBag)
        
        self.viewModel.successMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                let pop2 = PopupDialog(title: "Concluido", message: message, image: nil, buttonAlignment: UILayoutConstraintAxis.horizontal, transitionStyle: PopupDialogTransitionStyle.fadeIn, gestureDismissal: true, completion: {
                    self.viewModel.successFullSignUp.value = true
                })
                self.present(pop2, animated: true, completion: nil)
            }).disposed(by: viewModel.disposeBag)
    }

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            dismissKeyboard()
            viewModel.tryToSignUp()
        }
        return false
    }
}
