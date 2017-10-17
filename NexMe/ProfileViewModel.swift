//
//  ProfileViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 11/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class ProfileViewModel {
    var useCases: UseCases!
    var router: ProfileRouter!
    var disposeBag = DisposeBag()
    
    let name = Variable<String>("")
    let email = Variable<String>("")
    let avatarImageURL = Variable<URL?>(nil)
    
    func viewDidLoad() {
        if let user = useCases.getCurrentUser() {
            name.value = user.name.capitalized
            email.value = user.email
            self.avatarImageURL.value = user.avatar?.original
        }
    }
    
    func presentProfile() {
        self.router.presentProfile()
    }
    
    
}
