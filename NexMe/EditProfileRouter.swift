//
//  EditProfileRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class EditProfileRouter {
    let useCases: UseCases!
    let window: UIWindow!
    var viewController : EditProfileViewController!
    var presentingViewController: UIViewController!
    
    init(useCases: UseCases, window: UIWindow) {
        self.useCases = useCases
        self.window = window
    }
    
    func presentEditProfileFromViewController(presentingViewController: UIViewController){
        self.presentingViewController = presentingViewController
        let viewModel = EditProfileViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewController = EditProfileViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func getViewController() -> UIViewController {
        let viewModel = EditProfileViewModel()
        viewModel.router = self
        viewModel.useCases = self.useCases
        self.viewController = EditProfileViewController(viewModel: viewModel)
        return self.viewController
    }
}

