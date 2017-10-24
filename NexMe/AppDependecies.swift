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
    let editProfileRouter: EditProfileRouter
    let usersRouter: UsersRouter
    let userDetailRouter: UserDetailRouter
    let newEventRouter: NewEventRouter
    let eventListRouter: EventListRouter
    let eventDetailRouter: EventDetailRouter
    let eventChatRouter: EventChatRouter
    
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
        self.editProfileRouter = EditProfileRouter(useCases: self.useCases, window: self.window)
        self.usersRouter = UsersRouter(useCases: self.useCases, window: self.window)
        self.userDetailRouter = UserDetailRouter(useCases: self.useCases, window: self.window)
        self.newEventRouter = NewEventRouter(window: self.window, useCases: self.useCases)
        self.eventListRouter = EventListRouter(useCases: self.useCases, window: self.window)
        self.eventDetailRouter = EventDetailRouter(useCases: self.useCases, window: self.window)
        self.eventChatRouter = EventChatRouter(useCases: self.useCases, window: self.window)
        
        // Routing
        self.signInRouter.mainRouter = mainRouter
        self.signInRouter.signUpRouter = self.signUpRouter
        self.signUpRouter.signInRouter = self.signInRouter
        self.usersRouter.userDetailRouter = self.userDetailRouter
        self.menuRouter.eventsRouter = self.eventsRouter
        self.menuRouter.signInRouter = self.signInRouter
        self.menuRouter.profileRouter = self.profileRouter
        self.menuRouter.usersRouter = self.usersRouter
        self.mainRouter.menuRouter = menuRouter
        self.mainRouter.eventsRouter = self.eventsRouter
        self.eventsRouter.newEventRouter = self.newEventRouter
        self.eventsRouter.eventListRouter = self.eventListRouter
        self.eventListRouter.eventDetailRouter = self.eventDetailRouter
        self.eventDetailRouter.eventChatRouter = self.eventChatRouter
    }
    
    func presentUI() {
        if useCases.userIsSignedIn {
            self.mainRouter.presentMain()
            self.store.deleteCurrentUser()
            self.useCases.fetchUser(completion: { (result) in
                print(result)
            })
        } else {
            self.signInRouter.presentSignIn()
        }
    }
}

