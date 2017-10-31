//
//  Functions.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import Firebase

func handleError(error: Error) -> String {
    if (error as NSError).code == -1009 {
        return "Cadê sua internet que estava aqui?"
    }
    
    if (error as NSError).code == -1001 {
        return "Servidor com problemas. =/ Logo voltamos!"
    }
    
    if let errCode = AuthErrorCode(rawValue: error._code){
        switch errCode{
        case .invalidEmail:
            return "Por favor inserir um endereço de email valido!!"
        case .userNotFound:
            return "Usuario não encontrado!!"
        case .wrongPassword:
            return "Senha incorreta!!"
        case .emailAlreadyInUse:
            return "Este email já esta sendo usado!!"
        case .weakPassword:
            return "Senha precisa ter mais que 5 digitos!!"
        default:
            return "\(error)"
        }
    }
    
    return "\(error)"
}

func negate(bool: Bool) -> Bool {
    return !bool
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
