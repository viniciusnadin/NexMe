//
//  AppDependecies.swift
//  NexMe
//
//  Created by Vinicius Nadin on 24/08/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import Foundation
import Firebase

struct AppDependecies {
    let window: UIWindow
    let authentication: Auth = Auth.auth()
    let database: Database = Database.database()
    let store: PersistenceInterface = Store()

    // Use Cases
    let useCases: UseCases
    
    // UI
    let signInRouter: SignInRouter
    let signUpRouter: SignUpRouter
    let mainRouter: MainRouter
    let menuRouter: MenuRouter
    let eventsRouter: EventsRouter
    let profileRouter: ProfileRouter
    
    init(window: UIWindow) {
        self.window = window
        
        // UseCases
        self.useCases = UseCases(authentication: self.authentication, database: self.database, store: self.store)
        
        // UI
        self.signInRouter = SignInRouter(window: self.window, useCases: self.useCases)
        self.signUpRouter = SignUpRouter(window: self.window, useCases: self.useCases)
        self.mainRouter = MainRouter(window: window)
        self.menuRouter = MenuRouter(useCases: useCases)
        self.eventsRouter = EventsRouter(window: self.window, useCases: self.useCases)
        self.profileRouter = ProfileRouter(useCases: self.useCases, window: self.window)
        
        // Routing
        self.signInRouter.mainRouter = mainRouter
        self.signInRouter.signUpRouter = self.signUpRouter
        self.signUpRouter.signInRouter = self.signInRouter
        self.menuRouter.eventsRouter = self.eventsRouter
        self.menuRouter.signInRouter = self.signInRouter
        self.menuRouter.profileRouter = self.profileRouter
        self.mainRouter.menuRouter = menuRouter
        self.mainRouter.eventsRouter = self.eventsRouter
    }
    
    func presentUI() {
        if useCases.userIsSignedIn {
            self.mainRouter.presentMain()
        } else {
            self.signInRouter.presentSignIn()
        }
    }
}

