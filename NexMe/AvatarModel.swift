import Foundation

final class AvatarModel: NSObject {
    var original: URL?
    var medium: URL?
    var thumb: URL?
    
    init(original: URL?, medium: URL?, thumb: URL?) {
        self.original = original
        self.medium = medium
        self.thumb = thumb
    }
}

extension AvatarModel {
    convenience init(avatar: Avatar?) {
        self.init(
            original: avatar?.original,
            medium: avatar?.medium,
            thumb: avatar?.thumb
        )
    }
}

extension AvatarModel : NSCoding {
    convenience init(coder decoder: NSCoder) {
        self.init(
            original: decoder.decodeObject(forKey:"original") as? URL,
            medium: decoder.decodeObject(forKey:"medium") as? URL,
            thumb: decoder.decodeObject(forKey:"thumb") as? URL
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(original, forKey: "original")
        aCoder.encode(medium, forKey: "medium")
        aCoder.encode(thumb, forKey: "thumb")
    }
}

extension Avatar {
    init(model: AvatarModel?) {
        self.init(
            original: model?.original,
            medium: model?.medium,
            thumb: model?.thumb
        )
    }
}
