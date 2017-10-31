//
//  LoggedUser.swift
//  NexMe
//
//  Created by Vinicius Nadin on 30/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class LoggedUser{
    var user = User()
    static let sharedInstance = LoggedUser()
    
    private init() {}
}
