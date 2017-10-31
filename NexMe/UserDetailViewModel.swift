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
    let events = Variable<[Event]>([])
    let followers = Variable<[UserKeys]>([])
    let following = Variable<[UserKeys]>([])
    let followingThisUser = Variable<Bool>(false)
    
    func viewDidLoad() {
        name.value = user.name!.capitalized
        email.value = user.email!
        followers.value = user.followers
        following.value = user.following
        self.avatarImageURL.value = user.avatar?.original
        self.useCases.findEventsByUser(id: user.id!, completion: { (events) in
            do {
                self.events.value = try events.getValue().sorted(by: { $0.date < $1.date })
            } catch {
                print("Erro Eventos")
            }
        })
    }
    
    func close() {
        self.router.dismissUserDetail()
    }
    
    func followUser() {
        if followingThisUser.value {
            followingThisUser.value = false
            
        } else {
            followingThisUser.value = true
        }
        if (user.id! != LoggedUser.sharedInstance.user.id!) {
            self.user.followAction(completion: {
                self.followers.value = self.user.followers
                self.following.value = self.user.following
            })
        }
    }
    
}
