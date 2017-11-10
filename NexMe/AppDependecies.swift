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

    // Use Cases
    let useCases: UseCases
    
    // UI
    let signInRouter: SignInRouter
    let signUpRouter: SignUpRouter
    let mainRouter: MainRouter
    let menuRouter: MenuRouter
    let eventsRouter: EventsRouter
    let profileRouter: ProfileRouter
    let usersRouter: UsersRouter
    let userDetailRouter: UserDetailRouter
    let newEventRouter: NewEventRouter
    let eventListRouter: EventListRouter
    let eventDetailRouter: EventDetailRouter
    let eventChatRouter: EventChatRouter
    let messagesRouter: MessagesRouter
    let chatRouter: ChatRouter
    
    init(window: UIWindow) {
        self.window = window
        
        // UseCases
        self.useCases = UseCases(authentication: self.authentication, database: self.database)
        
        // UI
        self.signInRouter = SignInRouter(window: self.window, useCases: self.useCases)
        self.signUpRouter = SignUpRouter(window: self.window, useCases: self.useCases)
        self.mainRouter = MainRouter(window: window)
        self.menuRouter = MenuRouter(useCases: useCases)
        self.eventsRouter = EventsRouter(window: self.window, useCases: self.useCases)
        self.profileRouter = ProfileRouter(useCases: self.useCases, window: self.window)
        self.usersRouter = UsersRouter(useCases: self.useCases, window: self.window)
        self.userDetailRouter = UserDetailRouter(useCases: self.useCases, window: self.window)
        self.newEventRouter = NewEventRouter(window: self.window, useCases: self.useCases)
        self.eventListRouter = EventListRouter(useCases: self.useCases, window: self.window)
        self.eventDetailRouter = EventDetailRouter(useCases: self.useCases, window: self.window)
        self.eventChatRouter = EventChatRouter(useCases: self.useCases, window: self.window)
        self.messagesRouter = MessagesRouter(window: self.window, useCases: self.useCases)
        self.chatRouter = ChatRouter(window: self.window, useCases: self.useCases)
        
        // Routing
        self.signInRouter.mainRouter = self.mainRouter
        self.signInRouter.signUpRouter = self.signUpRouter
        self.signUpRouter.signInRouter = self.signInRouter
        self.usersRouter.userDetailRouter = self.userDetailRouter
        self.userDetailRouter.chatRouter = self.chatRouter
        self.messagesRouter.chatRouter = self.chatRouter
        self.menuRouter.eventsRouter = self.eventsRouter
        self.menuRouter.signInRouter = self.signInRouter
        self.menuRouter.profileRouter = self.profileRouter
        self.menuRouter.usersRouter = self.usersRouter
        self.menuRouter.messagesRouter = self.messagesRouter
        self.mainRouter.menuRouter = menuRouter
        self.mainRouter.eventsRouter = self.eventsRouter
        self.eventsRouter.newEventRouter = self.newEventRouter
        self.eventsRouter.eventListRouter = self.eventListRouter
        self.eventListRouter.eventDetailRouter = self.eventDetailRouter
        self.eventDetailRouter.eventChatRouter = self.eventChatRouter
        self.userDetailRouter.eventDetailRouter = self.eventDetailRouter
        self.profileRouter.eventDetailRouter = self.eventDetailRouter
        self.eventChatRouter.userDetailRouter = self.userDetailRouter
        self.eventDetailRouter.editEventRouter = self.newEventRouter
    }
    
    func presentUI() {
        if useCases.userIsSignedIn {
            self.mainRouter.presentMain()
        } else {
            self.signInRouter.presentSignIn()
        }
    }
}

