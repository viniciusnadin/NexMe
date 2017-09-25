import Unbox

struct User {
    let id: Int
    let name: String
    let email: String
    let phone: String?
    var avatar: Avatar?
}

extension User: Unboxable {
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        email = try unboxer.unbox(key: "email")
        phone = unboxer.unbox(key: "phone")
        avatar = unboxer.unbox(key: "avatar")
    }
}
