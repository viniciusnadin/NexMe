//
//  ProfileRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 11/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class ProfileRouter {
    let useCases: UseCases!
    let window: UIWindow!
    var viewController : ProfileViewController!
    var editProfileRouter: EditProfileRouter!
    
    init(useCases: UseCases, window: UIWindow) {
        self.useCases = useCases
        self.window = window
    }
    
    func presentProfile() {
        let viewModel = ProfileViewModel()
        viewModel.useCases = self.useCases
        viewModel.router = self
        
        self.viewController = ProfileViewController(viewModel: viewModel)
        self.window.rootViewController = self.viewController
    }
    
    func getViewController() -> UIViewController {
        let viewModel = ProfileViewModel()
        viewModel.router = self
        viewModel.useCases = self.useCases
        self.viewController = ProfileViewController(viewModel: viewModel)
        return self.viewController
    }
    
    func presentEditProfile(){
        self.editProfileRouter.presentEditProfileFromViewController(presentingViewController: self.viewController)
    }
}
