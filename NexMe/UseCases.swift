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
                    success()
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
        } catch {
            print("Erro GuardLet UseCases SignUp")
        }
    }
    
    
    func getCurrentUser(){
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
