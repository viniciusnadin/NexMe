//
//  UserModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 11/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import Foundation

final class UserModel : NSObject {
    let id: Int
    let name: String
    let email: String
    let phone: String?
    let avatar: AvatarModel?
    
    init(id: Int, name: String, email: String, phone: String?, avatar: AvatarModel? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.avatar = avatar
    }
}

extension UserModel {
    convenience init(user: User) {
        self.init(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            avatar: AvatarModel(avatar: user.avatar)
        )
    }
}

extension UserModel : NSCoding {
    convenience init(coder decoder: NSCoder) {
        self.init(
            id: decoder.decodeObject(forKey: "id") as? Int ?? 0,
            name: decoder.decodeObject(forKey: "name") as? String ?? "",
            email: decoder.decodeObject(forKey: "email") as? String ?? "",
            phone: decoder.decodeObject(forKey: "phone") as? String ?? "",
            avatar: decoder.decodeObject(forKey: "avatar") as? AvatarModel
        )
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(avatar, forKey: "avatar")
    }
}

extension User {
    init(model: UserModel) {
        self.init(
            id: model.id,
            name: model.name,
            email: model.email,
            phone: model.phone,
            avatar: Avatar(model: model.avatar)
        )
    }
}
