//
//  PopupDialog.swift
//  NexMe
//
//  Created by Vinicius Nadin on 05/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import PopupDialog

class PopUpDialog {
    
    static func present(title: String, message: String, viewController: UIViewController) {
        let popup = PopupDialog(title: title, message: message)
        viewController.present(popup, animated: true, completion: nil)
    }
}
