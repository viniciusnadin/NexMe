//
//  EventsRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class EventsRouter {
    let window: UIWindow
    let useCases: UseCases
    var viewController: EventsViewController!
    var newEventRouter: NewEventRouter!
    var eventListRouter: EventListRouter!
    
    init(window: UIWindow, useCases: UseCases) {
        self.window = window
        self.useCases = useCases
    }

    dynamic func presentEvents() {
        let viewModel = EventsViewModel()
        viewModel.useCases = useCases
        viewModel.router = self
        
        viewController = EventsViewController(viewModel: viewModel)
        window.rootViewController = viewController
    }
    
    func getViewController() -> UIViewController {
        let viewModel = EventsViewModel()
        viewModel.router = self
        viewModel.useCases = useCases
        
        viewController = EventsViewController(viewModel: viewModel)
        return viewController
    }
    
    func presentNewEvent() {
        self.newEventRouter.presentNewEventFromViewController(presentingViewController: self.viewController)
    }
    
    func presentEventsByFilter(categorie: EventCategorie){
        self.eventListRouter.presentEventsFromViewController(presentingViewController: self.viewController, categorie: categorie)
    }
    
}
