//
//  SignInViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 24/08/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class SignInViewModel {
    var useCases: UseCases!
    var router: SignInRouter!
    let disposeBag = DisposeBag()
    
    let email = Variable<String>("")
    let password = Variable<String>("")
    let errorMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    
    func signIn() {
        self.router.presentSignIn()
    }
    
    func tryToSignIn(){
        self.useCases.signIn(email: email.value, password: password.value, completion: { (result) in
            do {
                try result.check()
                self.router.presentMain()
            } catch {
                self.errorMessage.value = handleError(error: error as NSError)
            }
        })
    }
    
    func signUp() {
        self.router.presentSignUp()
    }
}
