//
//  UsersRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class UsersRouter {
    let useCases: UseCases!
    let window: UIWindow!
    var viewController : UsersViewController!
    var userDetailRouter: UserDetailRouter!
    
    init(useCases: UseCases, window: UIWindow) {
        self.useCases = useCases
        self.window = window
    }
    
    func presentUserSearch() {
        let viewModel = UsersViewModel()
        viewModel.useCases = self.useCases
        viewModel.router = self
        
        self.viewController = UsersViewController(viewModel: viewModel)
        self.window.rootViewController = self.viewController
    }
    
    func getViewController() -> UIViewController {
        let viewModel = UsersViewModel()
        viewModel.router = self
        viewModel.useCases = self.useCases
        self.viewController = UsersViewController(viewModel: viewModel)
        return self.viewController
    }
    
    func presentUserDetail(user: User){
        userDetailRouter.presentUserDetailFromViewController(presentingViewController: self.viewController, user: user)
    }
    
}
