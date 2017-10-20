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

struct Event {
    var title : String
    var coordinate : CLLocationCoordinate2D
    var locationName : String
    var date : Date
    var image : UIImage
    var description : String
    var categorie : EventCategorie
    var ownerId: User
}
