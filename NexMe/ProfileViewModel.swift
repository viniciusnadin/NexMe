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
    
    func presentProfile() {
        self.router.presentProfile()
    }
    
//    func loadUser
    
    
}
