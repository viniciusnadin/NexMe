//
//  MenuRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class MenuRouter {
    let useCases: UseCases
    
    var viewController: MenuViewController!
    var eventsRouter: EventsRouter!
    var signInRouter: SignInRouter!
    var profileRouter: ProfileRouter!
    var usersRouter: UsersRouter!
    var messagesRouter: MessagesRouter!
    
    init(useCases: UseCases) {
        self.useCases = useCases
    }

    func getViewController() -> UIViewController {
        let viewModel = MenuViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        
        viewController = MenuViewController(viewModel: viewModel)
        return viewController
    }

    func presentEvents() {
        viewController.slideMenuController()?.changeMainViewController(self.eventsRouter.getViewController(), close: true)
    }
    
    func presentSignIn() {
        self.signInRouter.presentSignIn()
    }
    
    func presentProfile() {
        self.viewController.slideMenuController()?.changeMainViewController(self.profileRouter.getViewController(), close: true)
    }
    
    func presentUserSearch() {
        self.viewController.slideMenuController()?.changeMainViewController(self.usersRouter.getViewController(), close: true)
    }
    
    func presentMessages() {
        self.viewController.slideMenuController()?.changeMainViewController(self.messagesRouter.getViewController(), close: true)
    }
}

