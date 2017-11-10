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
import Firebase

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
    var participants = [UserKeys]()
    
    init(title: String, coordinate: CLLocationCoordinate2D, locationName: String, date: Date, description: String, categorie: EventCategorie,
         ownerId: String, city: String){
        self.title = title
        self.coordinate = coordinate
        self.locationName = locationName
        self.date = date
        self.description = description
        self.categorie = categorie
        self.ownerId = ownerId
        self.city = city
    }
    
    
    func participate(completion: @escaping () -> ()) {
        let loggedUser = LoggedUser.sharedInstance.user
        let databaseReference = Database.database().reference()
        let key = Database.database().reference().childByAutoId().key
        let participating = ["participating/\(key)" : self.id!]
        let participants = ["participants/\(key)" : loggedUser.id!]
        if let participantKey = self.userIsParticipating() {
            databaseReference.child("users").child(loggedUser.id!).child("participating").child(participantKey).removeValue()
            databaseReference.child("event").child("events").child(self.id!).child("participants").child(participantKey).removeValue()
            completion()
        } else {
            databaseReference.child("users").child(loggedUser.id!).updateChildValues(participating)
            databaseReference.child("event").child("events").child(self.id!).updateChildValues(participants)
            self.participants.append(UserKeys(key: key, id: loggedUser.id!))
            loggedUser.eventsParticipating.append(UserKeys(key: key, id: self.id!))
            completion()
        }
    }
    
    fileprivate func userIsParticipating() -> String? {
        let loggedUser = LoggedUser.sharedInstance.user
        let eventsParticipating = loggedUser.eventsParticipating
        let participants = self.participants
        var participating = false
        var key : String = ""
        for i in 0..<eventsParticipating.count{
            if eventsParticipating[i].id == self.id!{
                key = eventsParticipating[i].key
                loggedUser.eventsParticipating.remove(at: i)
                participating = true
            }
        }
        if participating {
            for i in 0..<self.participants.count{
                if participants[i].id == loggedUser.id!{
                    key = participants[i].key
                    self.participants.remove(at: i)
                }
            }
        }
        if key == "" {
            return nil
        } else {
            return key
        }
    }
}
