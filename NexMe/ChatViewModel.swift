//
//  ChatViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 31/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class ChatViewModel {
    var useCases: UseCases!
    var router: ChatRouter!
    let disposeBag = DisposeBag()
    let messages = Variable<[Message]>([])
    var user: Variable<User>!
    let name = Variable<String>("")
    let message = Variable<String>("")
    
    func viewDidLoad() {
        self.useCases.chatMessages.asObservable().subscribe({
            self.messages.value = $0.element!
        }).disposed(by: self.disposeBag)
        self.useCases.observeChatMessages(user: self.user.value)
    }
    
    func setUser(user: User) {
        self.user = Variable<User>(user)
        self.name.value = user.name!.capitalized
    }
    
    func close() {
        self.router.dismiss()
    }
    
    func sendMessage() {
        if !self.message.value.isEmpty {
            self.useCases.sendMessage(message: message.value, user: user.value)
            self.message.value = ""
        }
    }
    
}
