import Unbox

struct Avatar {
    let original: URL?
    let medium: URL?
    let thumb: URL?
}

extension Avatar: Unboxable {
    init(unboxer: Unboxer) throws {
        original = unboxer.unbox(key: "original")
        medium = unboxer.unbox(key: "medium")
        thumb = unboxer.unbox(key: "thumb")
    }
}
