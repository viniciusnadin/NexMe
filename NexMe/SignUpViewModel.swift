//
//  SignupViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 07/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class SignUpViewModel {
    var useCases: UseCases!
    var router: SignUpRouter!
    let disposeBag = DisposeBag()
    
    let name = Variable<String>("")
    let email = Variable<String>("")
    let password = Variable<String>("")
    let errorMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    
    func signUp() {
        self.router.presentSignUp()
    }
    
    func tryToSignUp(){
        self.loading.value = true
        self.useCases.signUp(email: self.email.value, password: self.password.value, name: self.name.value) { (result) in
            do {
                self.loading.value = false
                try result.check()
                // Conseguiu logar
                //                self.successMessage.value = "Senha alterada com sucesso. :)"
                //                self.router.dismissChangePasword()
            } catch {
                self.errorMessage.value = handleError(error: error as NSError)
            }
        }
    }
    
    func signIn(){
        self.router.presentSignIn()
    }
    
    func close() {
        self.router.dismissSignUp()
    }
}
