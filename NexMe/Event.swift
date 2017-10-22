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
    var image : UIImage
    var description : String
    var categorie : EventCategorie
    var ownerId: String
    var owner: User?
    var city: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, locationName: String, date: Date, image: UIImage, description: String, categorie: EventCategorie, ownerId: String, city: String){
        self.title = title
        self.coordinate = coordinate
        self.locationName = locationName
        self.date = date
        self.image = image
        self.description = description
        self.categorie = categorie
        self.ownerId = ownerId
        self.city = city
    }
}
