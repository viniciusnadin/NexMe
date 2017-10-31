//
//  MessagesRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 30/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class MessagesRouter {
    let window: UIWindow
    let useCases: UseCases
    var viewController: MessagesViewController!
    var messagesRouter: MessagesRouter!
    
    init(window: UIWindow, useCases: UseCases) {
        self.window = window
        self.useCases = useCases
    }
    
    dynamic func presentMessages() {
        let viewModel = MessagesViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        
        viewController = MessagesViewController(viewModel: viewModel)
        window.rootViewController = viewController
    }
    
    func getViewController() -> UIViewController {
        let viewModel = MessagesViewModel()
        viewModel.router = self
        viewModel.useCases = useCases
        
        viewController = MessagesViewController(viewModel: viewModel)
        return viewController
    }
    
}
