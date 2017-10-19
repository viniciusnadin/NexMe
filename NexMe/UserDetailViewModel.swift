//
//  UserDetailViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 19/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class UserDetailViewModel {
    var useCases: UseCases!
    var router: UserDetailRouter!
    var user : User!
    
    var disposeBag = DisposeBag()
    let name = Variable<String>("")
    let email = Variable<String>("")
    let avatarImageURL = Variable<URL?>(nil)
    
    func viewDidLoad() {
        name.value = user.name.capitalized
        email.value = user.email
        self.avatarImageURL.value = user.avatar?.original
    }
    
    func close() {
        self.router.dismissUserDetail()
    }
    
}
