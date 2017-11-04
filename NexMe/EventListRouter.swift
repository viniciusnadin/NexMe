//
//  EventListRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class EventListRouter {
    let useCases: UseCases!
    let window: UIWindow!
    var viewController : EventListViewController!
    var presentingViewController: UIViewController!
    var eventDetailRouter: EventDetailRouter!
    
    init(useCases: UseCases, window: UIWindow) {
        self.useCases = useCases
        self.window = window
    }
    
    func presentEventsFromViewController(presentingViewController: UIViewController, categorie: EventCategorie?, city: String?){
        self.presentingViewController = presentingViewController
        let viewModel = EventListViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        if categorie != nil {
            viewModel.filter.value = categorie!.name.uppercased()
            viewModel.eventCategorie = categorie
        } else{
            viewModel.filter.value = city!
        }
        viewController = EventListViewController(viewModel: viewModel)
        viewController.isHeroEnabled = true
        viewController.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.viewController.isHeroEnabled = true
        self.viewController.heroModalAnimationType = .pull(direction: HeroDefaultAnimationType.Direction.right)
        self.viewController.hero_dismissViewController()
    }
    
    
    func presentEventDetail(event: Event){
        self.eventDetailRouter.presentEventFromViewController(presentingViewController: self.viewController, event: event)
    }
    
}
