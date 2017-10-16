import Unbox

struct User {
    let id: String
    let name: String
    let email: String
    var avatar: Avatar?
}

extension User: Unboxable {
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        email = try unboxer.unbox(key: "email")
        avatar = unboxer.unbox(key: "avatar")
    }
}
