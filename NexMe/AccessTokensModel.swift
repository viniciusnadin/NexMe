import Foundation

final class AccessTokensModel : NSObject {
    let accessToken: String
    let expirationDate: Double
    let refreshToken: String
    
    init(accessToken: String, expirationDate: Double, refreshToken: String) {
        self.accessToken = accessToken
        self.expirationDate = expirationDate
        self.refreshToken = refreshToken
    }
}

extension AccessTokensModel {
    convenience init(accessTokens: AccessTokens) {
        self.init(
            accessToken: accessTokens.accessToken,
            expirationDate: accessTokens.expirationDate,
            refreshToken: accessTokens.refreshToken
        )
    }
}

extension AccessTokensModel : NSCoding {
    convenience init(coder decoder: NSCoder) {
        self.init(
            accessToken: decoder.decodeObject(forKey: "accessToken") as! String,
            expirationDate: decoder.decodeDouble(forKey: "expirationDate"),
            refreshToken: decoder.decodeObject(forKey: "refreshToken") as! String
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(expirationDate, forKey: "expirationDate")
        aCoder.encode(refreshToken, forKey: "refreshToken")
    }
}

extension AccessTokens {
    init(model: AccessTokensModel) {
        self.init(
            accessToken: model.accessToken,
            expirationDate: model.expirationDate,
            refreshToken: model.refreshToken
        )
    }
}
