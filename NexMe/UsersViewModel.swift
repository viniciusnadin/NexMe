//
//  UsersViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class UsersViewModel {
    var useCases: UseCases!
    var router: UsersRouter!
    var disposeBag = DisposeBag()
    let textEntry = Variable<String>("")
    let users = Variable<[User]>([])
    
    func viewDidLoad() {
        //do-something
    }
    
    func presentUsersSearch() {
        
    }
    
    func searchUser() {
        self.useCases.searchUserByName(name: self.textEntry.value) { (users) in
            print("\(users)")
        }
    }
    
}
