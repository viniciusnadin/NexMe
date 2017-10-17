//
//  EditProfileViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class EditProfileViewModel {
    var useCases: UseCases!
    var router: EditProfileRouter!
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
}

