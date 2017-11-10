//
//  EventDetailViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class EventDetailViewModel {
    var useCases: UseCases!
    var router: EventDetailRouter!
    let disposeBag = DisposeBag()
    var event: Variable<Event>!
    let participatingThisEvent = Variable<Bool>(false)
    let participantsCount = Variable<Int>(0)
    
    func viewDidLoad() {
    }
    
    func setEvent(event: Event) {
        self.event = Variable<Event>(event)
        self.participantsCount.value = event.participants.count
        for participant in event.participants {
            if participant.id == LoggedUser.sharedInstance.user.id{
                self.participatingThisEvent.value = true
            }
        }
    }
    
    func close() {
        self.router.dismiss()
    }
    
    func presentEditEvent() {
        self.router.presentEditEvent(event: self.event.value)
    }
    
    func presentEventMessages() {
        self.router.presentEventMessages(event: self.event.value)
    }
    
    func subscribeOnEvent() {
        self.event.value.participate {
            self.participatingThisEvent.value = !self.participatingThisEvent.value
            self.participantsCount.value = self.event.value.participants.count
        }
    }
    
    func tapOnJoin() {
        if self.selfEvent() {
            self.presentEditEvent()
        } else {
            self.subscribeOnEvent()
        }
    }
    
    func selfEvent() -> Bool {
        return event.value.ownerId == LoggedUser.sharedInstance.user.id!
    }
}
