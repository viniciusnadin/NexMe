import Foundation

protocol PersistenceInterface {
    
    func saveCurrentUser(user: User)
    func getCurrentUser() -> User?
    func deleteCurrentUser()
}
