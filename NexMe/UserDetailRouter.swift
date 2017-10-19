//
//  UserDetailRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 19/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class UserDetailRouter {
    let useCases: UseCases!
    let window: UIWindow!
    var viewController : UserDetailViewController!
    var presentingViewController: UIViewController!
    
    init(useCases: UseCases, window: UIWindow) {
        self.useCases = useCases
        self.window = window
    }
    
    func presentUserDetailFromViewController(presentingViewController: UIViewController, user: User){
        self.presentingViewController = presentingViewController
        let viewModel = UserDetailViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewModel.user = user
        viewController = UserDetailViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func dismissUserDetail() {
        self.viewController.isHeroEnabled = true
        self.viewController.heroModalAnimationType = .pull(direction: HeroDefaultAnimationType.Direction.right)
        self.viewController.hero_dismissViewController()
    }
    
    func getViewController() -> UIViewController {
        let viewModel = UserDetailViewModel()
        viewModel.router = self
        viewModel.useCases = self.useCases
        self.viewController = UserDetailViewController(viewModel: viewModel)
        return self.viewController
    }
    
}
