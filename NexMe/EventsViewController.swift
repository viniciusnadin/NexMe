//
//  EventsViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 10/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SlideMenuControllerSwift

class EventsViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: EventsViewModel
    
    // MARK: - Outlets
    @IBOutlet weak var menuButton: UIButton!
    
    
    init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).addDisposableTo(viewModel.disposeBag)
    }

}
