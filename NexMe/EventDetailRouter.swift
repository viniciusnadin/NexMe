//
//  EventDetailRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class EventDetailRouter {
    let useCases: UseCases!
    let window: UIWindow!
    var viewController : EventDetailViewController!
    var presentingViewController: UIViewController!
    
    init(useCases: UseCases, window: UIWindow) {
        self.useCases = useCases
        self.window = window
    }
    
    func presentEventFromViewController(presentingViewController: UIViewController, event: Event){
        self.presentingViewController = presentingViewController
        let viewModel = EventDetailViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewModel.setEvent(event: event)
        viewController = EventDetailViewController(viewModel: viewModel)
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
