//
//  Event.swift
//  NexMe
//
//  Created by Vinicius Nadin on 19/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces

class Event {
    var title : String
    var coordinate : CLLocationCoordinate2D
    var locationName : String
    var date : Date
    var image : URL?
    var description : String
    var categorie : EventCategorie
    var ownerId: String
    var owner: User?
    var city: String
    var id: String?
    var vacancies: Int
    var participants = [String]()
    
    init(title: String, coordinate: CLLocationCoordinate2D, locationName: String, date: Date, description: String, categorie: EventCategorie,
         ownerId: String, city: String, vacancies: Int){
        self.title = title
        self.coordinate = coordinate
        self.locationName = locationName
        self.date = date
        self.description = description
        self.categorie = categorie
        self.ownerId = ownerId
        self.city = city
        self.vacancies = vacancies
    }
    
}
