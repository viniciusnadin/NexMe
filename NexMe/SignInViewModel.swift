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
    let successMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    let successLogin = Variable<Bool>(false)
    
    func signIn() {
        self.router.presentSignIn()
    }
    
    func tryToSignIn(){
        if(self.email.value.isEmpty) {
            self.errorMessage.value = "Você deve digitar um email!"
        } else if(self.password.value.isEmpty) {
            self.errorMessage.value = "Você deve digitar uma senha!"
        } else {
            self.loading.value = true
            self.useCases.signIn(email: email.value, password: password.value, completion: { (result) in
                do {
                    self.loading.value = false
                    try result.check()
                    self.successMessage.value = "Você foi autênticado com sucesso!"
                } catch {
                    self.errorMessage.value = handleError(error: error as NSError)
                }
            })
        }
    }
    
    func signUp() {
        self.router.presentSignUp()
    }
}
