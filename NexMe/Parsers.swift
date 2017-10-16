import Unbox
import SwiftyJSON

func parseAvatar(data: Data) throws -> Avatar {
    
    return try unbox(data: data)
}

func parseUser(data: UnboxableDictionary) throws -> User {
    return try unbox(dictionary: data)
}




























