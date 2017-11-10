//
//  EventsViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class EventsViewModel {
    var useCases: UseCases!
    var router: EventsRouter!
    let disposeBag = DisposeBag()
    var city = ""
    
    let categories = Variable<[EventCategorie]>([])
    
    func viewDidLoad() {
        self.useCases.findAllCategories(completion: { (categories) in
            let array = categories.value!
            self.categories.value.removeAll()
            self.categories.value.append(contentsOf: array)
        })
    }
    
    let errorMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    
    func events() {
        self.router.presentEvents()
    }
    
    func newEvent() {
        self.router.presentNewEvent()
    }
    
    func eventsByFilter(categorie: EventCategorie?, city: String?) {
        self.router.presentEventsByFilter(categorie: categorie, city: city)
    }
    
}
