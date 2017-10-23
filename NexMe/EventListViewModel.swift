//
//  EventListViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class EventListViewModel {
    var useCases: UseCases!
    var router: EventListRouter!
    var disposeBag = DisposeBag()
    let events = Variable<[Event]>([])
    let filter = Variable<String>("")
    var eventCategorie: EventCategorie!
    
    func viewDidLoad() {
        self.useCases.findEventByCategorie(categorie: self.eventCategorie) { (events) in
            let array = events.value!
            self.events.value.removeAll()
            self.events.value.append(contentsOf: array)
        }
    }
    
    func close() {
        self.router.dismiss()
    }
    
    func presentEventDetail(event: Event) {
        self.router.presentEventDetail(event: event)
    }
}
