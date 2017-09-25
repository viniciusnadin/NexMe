import Unbox

struct AccessTokens {
    let accessToken: String
    let expirationDate: Double
    let refreshToken: String
}

extension AccessTokens: Unboxable {
    init(unboxer: Unboxer) throws {
        accessToken = try unboxer.unbox(key: "access_token")
        expirationDate = try unboxer.unbox(key: "expiration_date")
        refreshToken = try unboxer.unbox(key: "refresh_token")
    }
}
