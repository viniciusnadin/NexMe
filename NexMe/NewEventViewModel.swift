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
    let categories = Variable<[EventCategorie]>([])
    
    let successMessage = Variable<String>("")
    let errorMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    
    let eventName = Variable<String>("")
    let date = Variable<Date>(Date())
    var eventLocation : CLLocationCoordinate2D!
    let eventLocationName = Variable<String>("")
    let eventDescription = Variable<String>("")
    var categorie: EventCategorie!
    let successCreation = Variable<Bool>(false)
    var city = ""
    var eventImage : UIImage!
    var event : Event!
    
    func viewDidLoad() {
        self.useCases.findAllCategories(completion: { (categories) in
            let array = categories.value!
            self.categories.value.removeAll()
            self.categories.value.append(contentsOf: array)
        })
    }
    
    func uploadImage(image: UIImage) {
        let data = UIImageJPEGRepresentation(image, 1.0)!
        self.useCases.uploadEventImage(image: data) { (result) in
            do {
                try result.check()
            } catch {
                print("ERRO")
            }
        }
    }
    
    func close() {
        self.router.dismiss()
    }
    
    func setEvent(event: Event) {
        self.event = event
        self.eventLocation = event.coordinate
        self.city = event.city
        self.categorie = event.categorie
        self.eventName.value = event.title
    }
    
    func save(){
        self.loading.value = true
        var saveEvent: Event!
        if self.event != nil{
            self.event.title = self.eventName.value
            self.event.coordinate = self.eventLocation
            self.event.locationName = self.eventLocationName.value
            self.event.date = self.date.value
            self.event.description = self.eventDescription.value
            self.event.categorie = self.categorie
            self.event.city = self.city
        } else {
            saveEvent = Event(title: self.eventName.value, coordinate: self.eventLocation, locationName: self.eventLocationName.value, date: self.date.value, description: self.eventDescription.value, categorie: self.categorie, ownerId: self.useCases.getUserId(), city: self.city)
        }
        if self.eventImage != nil {
            let data = UIImageJPEGRepresentation(self.eventImage, 1.0)!
            self.useCases.uploadEventImage(image: data) { (imageUrl) in
                do{
                    if self.event != nil {
                        self.event.image = try imageUrl.getValue()
                        self.createEvent(event: self.event)
                    } else {
                        saveEvent.image = try imageUrl.getValue()
                        self.createEvent(event: saveEvent)
                    }
                } catch{
                    print("Erro descompactar image")
                }
            }
        }
        else {
            if self.event != nil {
                self.createEvent(event: self.event)
            }else{
                self.createEvent(event: saveEvent)
            }
        }
    }
    
    fileprivate func createEvent(event: Event){
        self.useCases.createEvent(event: event, completion: { (result) in
            do {
                self.loading.value = false
                try result.check()
                self.successMessage.value = "O evento foi marcado!!"
            } catch {
                self.errorMessage.value = handleError(error: error as NSError)
            }
        })
    }
    
    
}

