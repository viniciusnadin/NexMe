//
//  MessagesViewModel.swift
//  NexMe
//
//  Created by Vinicius Nadin on 30/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import RxSwift

class MessagesViewModel {
    var useCases: UseCases!
    var router: MessagesRouter!
    let disposeBag = DisposeBag()
    let messages = Variable<[Message]>([])
    
    func viewDidLoad() {
        self.useCases.messagesDictionary.asObservable().subscribe({
            self.messages.value = Array($0.element!.values)
        }).disposed(by: self.disposeBag)
        self.useCases.observeUserMessages()
    }
    
}
