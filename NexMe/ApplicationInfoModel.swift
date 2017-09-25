import Foundation

final class ApplicationInfoModel: NSObject {
    let lastVersion: String?
    let deviceToken: String?
    let needLoad: Bool?
    let cardStatusChange: Bool?
    
    init(lastVersion: String?, deviceToken: String?, needLoad: Bool?, cardStatusChange: Bool?) {
        self.lastVersion = lastVersion
        self.deviceToken = deviceToken
        self.needLoad = needLoad
        self.cardStatusChange = cardStatusChange
    }
}

extension ApplicationInfoModel {
    convenience init(applicationInfo: ApplicationInfo) {
        self.init(
            lastVersion: applicationInfo.lastVersion,
            deviceToken: applicationInfo.deviceToken,
            needLoad:  applicationInfo.needLoad,
            cardStatusChange: applicationInfo.cardStatusChange
        )
    }
}

extension ApplicationInfoModel: NSCoding {
    convenience init(coder decoder: NSCoder) {
        self.init (
            lastVersion: decoder.decodeObject(forKey: "lastVersion") as? String ?? "",
            deviceToken: decoder.decodeObject(forKey: "deviceToken") as? String ?? "",
            needLoad:  decoder.decodeObject(forKey: "needLoad") as? Bool ?? false,
            cardStatusChange: decoder.decodeObject(forKey: "cardStatusChange") as? Bool ?? false
        )
    }
    
    
    func encode(with aCoder: NSCoder) {
        if lastVersion != nil {
            aCoder.encode(lastVersion, forKey: "lastVersion")
        }
        if deviceToken != nil {
            aCoder.encode(deviceToken, forKey: "deviceToken")
        }
        if needLoad != nil {
            aCoder.encode(needLoad, forKey: "needLoad")
        }
        
        if cardStatusChange != nil {
            aCoder.encode(cardStatusChange, forKey: "cardStatusChange")
        }
    }
}

extension ApplicationInfo {
    init(model: ApplicationInfoModel) {
        self.init (
            lastVersion: model.lastVersion,
            deviceToken: model.deviceToken,
            needLoad:  model.needLoad,
            cardStatusChange: model.cardStatusChange
        )
    }
}
