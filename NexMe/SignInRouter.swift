//
//  SignInRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 24/08/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class SignInRouter {
    let window: UIWindow
    let useCases: UseCases
    
    var viewController: SignInViewController!
    var signUpRouter: SignUpRouter!
    var mainRouter: MainRouter!
    var presentingViewController: UIViewController!
    
    init(window: UIWindow, useCases: UseCases) {
        self.window = window
        self.useCases = useCases
    }
    
    dynamic func presentSignIn() {
        let viewModel = SignInViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        
        viewController = SignInViewController(viewModel: viewModel)
        window.rootViewController = viewController
    }
    
    func presentSignUp(){
        signUpRouter.presentSignUpFromViewController(presentingViewController: self.viewController)
    }
    
    func presentSignInFromViewController(presentingViewController: UIViewController){
        self.presentingViewController = presentingViewController
        let viewModel = SignInViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewController = SignInViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.right)
        presentingViewController.hero_replaceViewController(with: viewController)
    }
    
    func presentMain() {
        mainRouter.presentMain()
    }
}
