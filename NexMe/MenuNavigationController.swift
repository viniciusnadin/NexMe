//
//  MenuNavigationController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MenuNavigationController: SlideMenuController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}



