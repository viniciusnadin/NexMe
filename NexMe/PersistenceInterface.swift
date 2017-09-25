import Foundation

protocol PersistenceInterface {
    func saveAccessTokens(accessTokens: AccessTokens)
    func getAccessTokens() -> AccessTokens?
    func deleteAccessTokens()
    
    func saveCurrentUser(user: User)
    func getCurrentUser() -> User?
    func deleteCurrentUser()
    
    func saveTimelineData(data: Data)
    func getTimelineData() -> Data?
    func deleteTimelineData()
    
    func saveApplicationInfo(info: ApplicationInfo)
    func getApplicationInfo() -> ApplicationInfo?
}
