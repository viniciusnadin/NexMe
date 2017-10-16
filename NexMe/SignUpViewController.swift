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
    @IBOutlet weak var titleView: UIView!
    
    
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
        let tapOnView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
    }
    
    deinit {
        print("LOG - DEINITING SIGNUP VIEW CONTROLLER")
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
        self.setPastelView()
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
    
    func setPastelView() {
        self.signUpButton.backgroundColor = UIColor(red: 175/255, green: 58/255, blue: 143/255, alpha: 0.8)
        self.signUpButton.layer.cornerRadius = 4
        
        let pastelView = PastelView(frame: self.titleView.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.setColors([UIColor(red: 98/255, green: 39/255, blue: 116/255, alpha: 1.0), UIColor(red: 197/255, green: 51/255, blue: 100/255, alpha: 1.0)])
        pastelView.startAnimation()
        self.titleView.insertSubview(pastelView, at: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func configureBinds() {
        self.signInButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        viewModel.loading.asObservable().map(negate)
            .bind(to:signUpButton.rx.isEnabled)
            .addDisposableTo(viewModel.disposeBag)
        
        viewModel.loading.asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .addDisposableTo(viewModel.disposeBag)
        
        signUpButton.rx.tap.subscribe(onNext: {
            self.dismissKeyboard()
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
        
        self.viewModel.successFullSignUp.asObservable().bind { (verify) in
            if verify {
                self.viewModel.close()
            }
        }.addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.errorMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                PopUpDialog.present(title: "Ops!", message: message, viewController: self)
        }).addDisposableTo(viewModel.disposeBag)
        
        self.viewModel.successMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                let pop2 = PopupDialog(title: "Concluido", message: message, image: nil, buttonAlignment: UILayoutConstraintAxis.horizontal, transitionStyle: PopupDialogTransitionStyle.fadeIn, gestureDismissal: true, completion: {
                    self.viewModel.successFullSignUp.value = true
                })
                self.present(pop2, animated: true, completion: nil)
            }).addDisposableTo(viewModel.disposeBag)
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
