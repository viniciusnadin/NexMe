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
    
    func viewDidLoad() {
//        self.useCases.findAllCategories(completion: { (categories) in
//            let array = categories.value!
//            self.categories.value.removeAll()
//            self.categories.value.append(contentsOf: array)
//        })
    }
    
    func setEvent(event: Event) {
        self.event = Variable<Event>(event)
    }
    
    func close() {
        self.router.dismiss()
    }
    
    func presentEventMessages() {
        self.router.presentEventMessages(event: self.event.value)
    }
}
