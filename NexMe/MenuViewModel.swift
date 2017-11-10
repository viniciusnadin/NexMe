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
        self.useCases.fetchUser(completion: { (result) in
            let user = LoggedUser.sharedInstance.user
            self.name.value = user.name!.capitalized
            self.email.value = user.email!
            self.avatarImageURL.value = user.avatar?.original
        })
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
    
    func presentMessages() {
        self.router.presentMessages()
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

