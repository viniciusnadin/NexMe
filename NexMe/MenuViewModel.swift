//
//  MenuViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class MenuViewModel {
    var useCases: UseCases!
    var router: MenuRouter!
    
    let disposeBag = DisposeBag()
    let name = Variable<String>("")
    let email = Variable<String>("")
    let successFullSignOut = Variable<Bool>(false)
    let avatarImageURL = Variable<URL?>(nil)
    
    func viewDidLoad() {
        if let user = useCases.getCurrentUser() {
            name.value = user.name.capitalized
            email.value = user.email
            self.avatarImageURL.value = user.avatar?.original
        }
    }
    
    func presentEvents() {
        router.presentEvents()
    }
    
    func signOut() {
        self.useCases.signOut()
        self.router.presentSignIn()
    }
    
    func presentProfile() {
        self.router.presentProfile()
    }
    
    func presentUsersSearch() {
        self.router.presentUserSearch()
    }
    
    func uploadImage(image: UIImage) {
        let data = UIImageJPEGRepresentation(image, 1.0)!
        self.useCases.uploadAvatar(avatar: data) { (result) in
            do {
                try result.check()
            } catch {
                print("ERRO")
            }
        }
    }

}

