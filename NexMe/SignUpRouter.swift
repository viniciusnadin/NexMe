//
//  SignUpRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 07/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class SignUpRouter {
    let window: UIWindow
    let useCases: UseCases
    
    var viewController: SignUpViewController!
    var presentingViewController: UIViewController!
    var signInRouter: SignInRouter!
    
    init(window: UIWindow, useCases: UseCases) {
        self.window = window
        self.useCases = useCases
    }
    
    dynamic func presentSignUp() {
        let viewModel = SignUpViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        
        viewController = SignUpViewController(viewModel: viewModel)
        window.rootViewController = viewController
    }
    
    func presentSignUpFromViewController(presentingViewController: UIViewController){
        self.presentingViewController = presentingViewController
        let viewModel = SignUpViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewController = SignUpViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func dismissSignUp() {
        self.viewController.isHeroEnabled = true
        self.viewController.heroModalAnimationType = .pull(direction: HeroDefaultAnimationType.Direction.right)
        self.viewController.hero_dismissViewController()
    }
}
