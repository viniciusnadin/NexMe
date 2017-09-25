import Foundation

class Store : PersistenceInterface {
    let bugfix = ""
    let file = FileStore()
    
    func saveAccessTokens(accessTokens: AccessTokens) {
        file.saveObject(object: AccessTokensModel(accessTokens: accessTokens), withName: "AccessTokens")
    }
    
    func getAccessTokens() -> AccessTokens? {
        let model = file.getObjectWithName(name: "AccessTokens") as? AccessTokensModel
        return model.map(AccessTokens.init)
    }
    
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
    
    func deleteAccessTokens() {
        file.deleteObjectWithName(name: "AccessTokens")
    }
    
    func saveTimelineData(data: Data) {
        file.saveObject(object: data as AnyObject, withName: "Timeline")
    }
    
    func getTimelineData() -> Data? {
        return file.getObjectWithName(name: "Timeline") as! Data? 
    }
    
    func deleteTimelineData() {
        file.deleteObjectWithName(name: "Timeline")
    }
    
    func getApplicationInfo() -> ApplicationInfo? {
        let model = file.getObjectWithName(name: "ApplicationInfo") as? ApplicationInfoModel
        return model.map(ApplicationInfo.init)
    }
    
    func saveApplicationInfo(info: ApplicationInfo) {
        file.saveObject(object: ApplicationInfoModel(applicationInfo: info), withName: "ApplicationInfo")
    }
}
