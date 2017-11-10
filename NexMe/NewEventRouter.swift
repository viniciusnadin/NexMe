//
//  NewEventRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 21/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class NewEventRouter {
    let window: UIWindow
    let useCases: UseCases
    var viewController: NewEventViewController!
    var presentingViewController: UIViewController!
    
    init(window: UIWindow, useCases: UseCases) {
        self.window = window
        self.useCases = useCases
    }
    
    func presentNewEventFromViewController(presentingViewController: UIViewController){
        self.presentingViewController = presentingViewController
        let viewModel = NewEventViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewController = NewEventViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func presentEditEventFromViewController(presentingViewController: UIViewController, event: Event){
        self.presentingViewController = presentingViewController
        let viewModel = NewEventViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        viewModel.setEvent(event: event)
        viewController = NewEventViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func getViewController() -> UIViewController {
        let viewModel = NewEventViewModel()
        viewModel.router = self
        viewModel.useCases = useCases
        
        viewController = NewEventViewController(viewModel: viewModel)
        return viewController
    }
    
    func dismiss() {
        self.viewController.isHeroEnabled = true
        self.viewController.heroModalAnimationType = .pull(direction: HeroDefaultAnimationType.Direction.right)
        self.viewController.hero_dismissViewController()
    }
    
}

