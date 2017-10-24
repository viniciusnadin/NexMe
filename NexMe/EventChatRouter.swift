//
//  EventChatRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 23/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class EventChatRouter {
    let useCases: UseCases!
    let window: UIWindow!
    var viewController : EventChatViewController!
    var presentingViewController: UIViewController!
    
    init(useCases: UseCases, window: UIWindow) {
        self.useCases = useCases
        self.window = window
    }
    
    func presentChatFromViewController(presentingViewController: UIViewController, event: Event){
        self.presentingViewController = presentingViewController
        let viewModel = EventChatViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewModel.setEvent(event: event)
        viewController = EventChatViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.viewController.isHeroEnabled = true
        self.viewController.heroModalAnimationType = .pull(direction: HeroDefaultAnimationType.Direction.right)
        self.viewController.hero_dismissViewController()
    }
    
}
