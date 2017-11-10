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
    @IBOutlet weak var lostPasswordButton: UIButton!
    
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
        }).disposed(by: viewModel.disposeBag)
        
        signUpButton.rx.tap.subscribe(onNext: {
            self.viewModel.signUp()
        }).disposed(by: viewModel.disposeBag)
        
        lostPasswordButton.rx.tap.subscribe(onNext: {
            let alert = UIAlertController(title: "Redefinir a senha", message: "Digite o seu email!", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            alert.addAction(UIAlertAction(title: "Redifinir", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.viewModel.useCases.passwordReset(email: textField?.text)
                PopUpDialog.present(title: "Redifinição de senha", message: "Enviamos um email com todas as instruções necessárias :)", viewController: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: viewModel.disposeBag)
        
        self.viewModel.successLogin.asObservable().bind { (verify) in
            if verify{self.viewModel.router.presentMain()}
            }.disposed(by: self.viewModel.disposeBag)
        
        emailTextField.rx.text.orEmpty.map({$0})
            .bind(to: viewModel.email)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.loading.asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.loading.asObservable().map(negate)
            .bind(to:signInButton.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)
        
        passwordTextField.rx.text.orEmpty.map({$0})
            .bind(to: viewModel.password)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.errorMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                PopUpDialog.present(title: "Ops!", message: message, viewController: self)
            }).disposed(by: viewModel.disposeBag)
        
        viewModel.successMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                let pop2 = PopupDialog(title: "Bem vindo!", message: message, image: nil, buttonAlignment: UILayoutConstraintAxis.horizontal, transitionStyle: PopupDialogTransitionStyle.fadeIn, gestureDismissal: true, completion: {
                    self.viewModel.successLogin.value = true
                })
                self.present(pop2, animated: true, completion: nil)
            }).disposed(by: viewModel.disposeBag)
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





