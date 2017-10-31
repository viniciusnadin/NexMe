import UIKit
import Firebase

class User {
    var id: String?
    var name: String?
    var email: String?
    var avatar: Avatar?
    var following = [UserKeys]()
    var followers = [UserKeys]()
    
    fileprivate var keyUserFollowing : String!
    fileprivate var keySelfFollower : String!
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    init() {
    }
    
    func followAction(completion: @escaping () -> ()) {
        let loggedUser = LoggedUser.sharedInstance.user
        let databaseReference = Database.database().reference()
        let key = Database.database().reference().child("users").childByAutoId().key
        let following = ["following/\(key)" : self.id!]
        let followers = ["followers/\(key)" : loggedUser.id!]
        if self.isFollowing() {
            databaseReference.child("users").child(loggedUser.id!).child("following").child(keyUserFollowing).removeValue()
            databaseReference.child("users").child(self.id!).child("followers").child(keySelfFollower).removeValue()
            completion()
        } else {
            databaseReference.child("users").child(loggedUser.id!).updateChildValues(following)
            databaseReference.child("users").child(self.id!).updateChildValues(followers)
            self.followers.append(UserKeys(key: key, id: loggedUser.id!))
            loggedUser.following.append(UserKeys(key: key, id: self.id!))
            completion()
        }
    }
    
    fileprivate func isFollowing() -> Bool {
        let loggedUser = LoggedUser.sharedInstance.user
        let fwing = loggedUser.following
        let fllwers = self.followers
        var following = false
        for i in 0..<fwing.count{
            if fwing[i].id == self.id!{
                self.keyUserFollowing = fwing[i].key
                loggedUser.following.remove(at: i)
                following = true
            }
        }
        if following {
            let loggedUser = LoggedUser.sharedInstance.user
            for i in 0..<fllwers.count{
                if fllwers[i].id == loggedUser.id!{
                    self.keySelfFollower = fllwers[i].key
                    self.followers.remove(at: i)
                }
            }
        }
        return following
    }
    
    func isFollowingUser() -> Bool {
        let loggedUser = LoggedUser.sharedInstance.user
        for user in loggedUser.following{
            if user.id == self.id{
                return true
            }
        }
        return false
    }
    
    
}

class UserKeys {
    var key : String!
    var id : String!

    init(key: String, id: String) {
        self.key = key
        self.id = id
    }
}


