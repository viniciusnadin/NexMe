//
//  MainRouter.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Hero

class MainRouter {
    let window: UIWindow
    var viewController: MenuNavigationController!
    var menuRouter: MenuRouter!
    var eventsRouter: EventsRouter!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func presentMain() {
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.size.width - 40
        viewController = MenuNavigationController(mainViewController: eventsRouter.getViewController(), leftMenuViewController: menuRouter.getViewController())
        if window.rootViewController == nil {
            window.rootViewController = viewController
        } else {
            viewController.isHeroEnabled = true
            viewController.heroModalAnimationType = .zoom
            window.rootViewController?.hero_replaceViewController(with: viewController)
        }
    }
}
