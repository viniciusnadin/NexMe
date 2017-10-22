//
//  UseCases
//  NexMe
//
//  Created by Vinicius Nadin on 24/08/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import Firebase
import PopupDialog
import RxCocoa
import RxSwift
import Unbox
import GooglePlaces
import GoogleMaps

final class UseCases {
    let authentication: Auth
    let database: Database
    let store: PersistenceInterface
    
    init(authentication: Auth, database: Database, store: PersistenceInterface) {
        self.authentication = authentication
        self.database = database
        self.store = store
    }
    
    var userIsSignedIn: Bool {
        return authentication.currentUser != nil
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void>) -> Void) {
        deliver(completion: completion) { (success, failure) in
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    failure(error!)
                }
                else {
                    self.fetchUser(completion: { (result) in
                        success()
                    })
                }
            })
        }
    }
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<Void>) -> Void) {
        deliver(completion: completion) { (success, failure) in
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    failure(error!)
                }
                else {
                    guard let uid = user?.uid else{
                        print("Erro GuardLet UseCases SignUp")
                        return
                    }
                    let userReference = Database.database().reference().child("users").child(uid)
                    let values = ["name":name.lowercased(), "email":email]
                    
                    userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            failure(err!)
                        } else {
                            success()
                        }
                    })
                    success()
                }
            })
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.store.deleteCurrentUser()
        } catch {
            print("Erro GuardLet UseCases SignUp")
        }
    }
    
    func fetchUser(completion: @escaping (Result<Void>) -> Void) {
        deliver(completion: completion) { success, failure in
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
                do {
                    let data = snapShot.value as! NSMutableDictionary
                    data.setObject((Auth.auth().currentUser?.uid)!, forKey: "id" as NSCopying)
                    let data2 = data as NSDictionary
                    let user = try parseUser(data: data2 as! UnboxableDictionary)
                    self.store.saveCurrentUser(user: user)
                    success()
                } catch {
                    failure(error)
                }
            })
        }
    }
    
    func uploadAvatar(avatar: Data, completion: @escaping (Result<Void>) -> Void) {
        deliver(completion: completion) { success, failure in
            let imageName = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child("\(imageName).png").putData(avatar, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    failure(error!)
                }
                let updateProfileImage = ["original" : metadata?.downloadURL()?.absoluteString as Any]
                let userId = Auth.auth().currentUser?.uid
                let usersReference = Database.database().reference().child("users").child(userId!).child("avatar")
                usersReference.updateChildValues(updateProfileImage)
                self.getUpdatedCurrentUser()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                success()
            })
        }
    }
    
    // DELETE
    func fetchAvatar(completion: @escaping (Result<UIImage>) -> Void) {
        deliver(completion: completion) { success, failure in
            if let url = self.getCurrentUser()?.avatar?.original{
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        failure(error!)
                    }
                    let image = UIImage(data: data!)
                    success(image!)
                    }.resume()
            }
            else{
                success(UIImage())
            }
        }
    }
    
    func searchUserByName(name: String, completion: @escaping (Result<[User]>) -> Void) {
        deliver(completion: completion) { success, failure in
            let searchUserDispatch = DispatchGroup()
            var arrayUsers = [User]()
            let userId = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").queryOrdered(byChild: "name").queryStarting(atValue: name.lowercased()).queryEnding(atValue: name.lowercased()+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapShot) in
                guard let values = (snapShot.value as? NSMutableDictionary) else {
                    success(arrayUsers)
                    return
                }
                for value in values{
                    if !((value.key as! String) == userId) {
                        do {
                            searchUserDispatch.enter()
                            let data = value.value as! NSMutableDictionary
                            data.setObject(value.key, forKey: "id" as NSCopying)
                            let data2 = data as NSDictionary
                            let user = try parseUser(data: data2 as! UnboxableDictionary)
                            arrayUsers.append(user)
                            searchUserDispatch.leave()
                        } catch {
                            failure(error)
                        }
                    }
                }
                searchUserDispatch.notify(queue: .main, execute: {
                    success(arrayUsers)
                })
            })
        }
    }
    
    func getUserId() -> String{
        return (Auth.auth().currentUser?.uid)!
    }
    
    func getCurrentUser() -> User? {
        return self.store.getCurrentUser()
    }
    
    func getUpdatedCurrentUser(){
        self.store.deleteCurrentUser()
        self.fetchUser(completion: { (user) in
            //nothing
        })
    }
    
    func createEvent(event : Event, completion: @escaping (Result<Void>) -> Void){
        deliver(completion: completion) { success, failure in
            let databaseReference = Database.database().reference()
            let eventsReference = databaseReference.child("event").child("events").childByAutoId()
            let values : [String : Any]!
            values = ["ownerId" : event.ownerId, "title" : event.title, "date" : Int((event.date.timeIntervalSince1970)), "description" : event.description, "image" : "party.jpg", "town" : event.city, "locationName" : event.locationName, "categorie" : event.categorie.id! as Any] as [String : Any]
            eventsReference.updateChildValues(values) { (error, reference) in
                if error != nil {
                    failure(error!)
                }
                let eventLocationReference = eventsReference.child("location")
                let locationValue = ["latitude" : event.coordinate.latitude, "longitude" : event.coordinate.longitude] as [String : CLLocationDegrees]
                eventLocationReference.updateChildValues(locationValue, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        failure(error!)
                    }
                    self.saveCity(name: event.city)
                    success()
                })
            }
        }
    }
    
    func saveCity(name: String){
        let value = [name : ""] as [String : String]
        Database.database().reference().child("city").child("cities").updateChildValues(value)
    }
    
    func createAllCategories(){
        let categoriesReference = Database.database().reference().child("event").child("categories")
        var values : [String : String]!
        let categories : [EventCategorie]!
        categories = [EventCategorie(name: "Festa"), EventCategorie(name: "Curso")]
        for categorie in categories {
            values = ["name" : categorie.name] as [String : String]
            categoriesReference.childByAutoId().updateChildValues(values) { (error, reference) in
                if error != nil {
                    print(error!)
                }
            }
        }
    }
    
    func findAllCategories(completion: @escaping (Result<[EventCategorie]>) -> Void){
        deliver(completion: completion) { success, failure in
            let databaseReference = Database.database().reference()
            var categories = [EventCategorie]()
            let eventCategorieDispatch = DispatchGroup()
            databaseReference.child("event").child("categories").observeSingleEvent(of: .value, with: { (snapShot) in
                if let dictionary = snapShot.value as? [String : [String : String]]{
                    for dic in dictionary {
                        eventCategorieDispatch.enter()
                        let name = (dic.value["name"])
                        let id = dic.key
                        let categorie = EventCategorie(name: name!)
                        categorie.id = id
                        categories.append(categorie)
                        eventCategorieDispatch.leave()
                    }
                    eventCategorieDispatch.notify(queue: .main, execute: {
                        success(categories)
                    })
                }
                else{
                    success(categories)
                    return
                }
            })
            
        }
    }
    
    
}
