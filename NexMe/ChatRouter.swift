//
//  ChatRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 31/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class ChatRouter {
    let window: UIWindow
    let useCases: UseCases
    var viewController: ChatViewController!
    var chatRouter: ChatRouter!
    var presentingViewController: UIViewController!
    
    init(window: UIWindow, useCases: UseCases) {
        self.window = window
        self.useCases = useCases
    }
    
    func presentChatFromViewController(presentingViewController: UIViewController, user: User){
        self.presentingViewController = presentingViewController
        let viewModel = ChatViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewModel.setUser(user: user)
        viewController = ChatViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    dynamic func presentChat() {
        let viewModel = ChatViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        
        viewController = ChatViewController(viewModel: viewModel)
        window.rootViewController = viewController
    }
    
    func getViewController() -> UIViewController {
        let viewModel = ChatViewModel()
        viewModel.router = self
        viewModel.useCases = useCases
        
        viewController = ChatViewController(viewModel: viewModel)
        return viewController
    }
    
    func dismiss() {
        self.viewController.isHeroEnabled = true
        self.viewController.heroModalAnimationType = .pull(direction: HeroDefaultAnimationType.Direction.right)
        self.viewController.hero_dismissViewController()
    }
    
}
