//
//  EventChatViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 23/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//
import RxSwift

class EventChatViewModel {
    var useCases: UseCases!
    var router: EventChatRouter!
    let disposeBag = DisposeBag()
    var event: Variable<Event>!
    let message = Variable<String>("")
    var messages = Variable<[EventMessage]>([])
    
    func viewDidLoad() {
        self.useCases.messages.asObservable().subscribe({
            self.messages.value.removeAll()
            self.messages.value = ($0.element)!
        }).disposed(by: self.disposeBag)
        self.useCases.observeMessages(eventId: self.event.value.id!)
    }
    
    func setEvent(event: Event) {
        self.event = Variable<Event>(event)
    }
    
    func sendMessage(){
        if !self.message.value.isEmpty {
            self.useCases.sendMessage(event: self.event.value, message: self.message.value)
        }
    }
    
    func close() {
        self.router.dismiss()
    }
}
