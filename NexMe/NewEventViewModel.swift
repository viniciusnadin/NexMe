//
//  NewEventViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 21/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift
import GooglePlaces
import GoogleMaps

class NewEventViewModel {
    var useCases: UseCases!
    var router: NewEventRouter!
    let disposeBag = DisposeBag()
    var event: Event!
    
    let errorMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    
    let eventName = Variable<String>("")
    let date = Variable<Date>(Date())
    var eventLocation : CLLocationCoordinate2D!
    let eventLocationName = Variable<String>("")
    let eventDescription = Variable<String>("")
    
    func close() {
        self.router.dismiss()
    }
    
    func save(){
        
    }
    
    
}

