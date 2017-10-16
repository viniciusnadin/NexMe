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
    let successMessage = Variable<String>("")
    let loading = Variable<Bool>(false)
    let successFullSignUp = Variable<Bool>(false)
    
    func signUp() {
        self.router.presentSignUp()
    }
    
    func tryToSignUp(){
        if self.name.value.isEmpty {
            self.errorMessage.value = "Por favor, digite um nome!"
        } else if self.email.value.isEmpty {
            self.errorMessage.value = "Por favor, digite um email!"
        } else if self.password.value.isEmpty {
            self.errorMessage.value = "Por favor, insira uma senha maior que 6 digitos!"
        } else {
            self.loading.value = true
            self.useCases.signUp(email: self.email.value, password: self.password.value, name: self.name.value) { (result) in
                do {
                    self.loading.value = false
                    try result.check()
                    self.successMessage.value = "Cadastro efetuado com sucesso!! :)"
                } catch {
                    self.errorMessage.value = handleError(error: error as NSError)
                }
            }
        }
    }
    
    func close() {
        self.router.dismissSignUp()
    }
}
