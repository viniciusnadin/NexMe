import Foundation

class Store : PersistenceInterface {
    let file = FileStore()
    
    func saveCurrentUser(user: User) {
        file.saveObject(object: UserModel(user: user), withName: "User")
    }
    
    func getCurrentUser() -> User? {
        let model = file.getObjectWithName(name: "User") as? UserModel
        return model.map(User.init)
    }

    func deleteCurrentUser() {
        file.deleteObjectWithName(name: "User")
    }
}
