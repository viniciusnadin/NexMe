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
    
    let errorMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    
    func events() {
        self.router.presentEvents()
    }
    
}
