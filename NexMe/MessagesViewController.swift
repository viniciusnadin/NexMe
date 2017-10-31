//
//  MessagesViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 30/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SlideMenuControllerSwift

class MessagesViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: MessagesViewModel
    let cellIdentifier = "userCell"

    // MARK: - Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var messagesTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.useCases.messagesDictionary.value.removeAll()
        self.configureViews()
        self.configureBinds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    init(viewModel: MessagesViewModel) {
        self.viewModel = viewModel
        self.viewModel.viewDidLoad()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.messages.asObservable().bind(to: messagesTable.rx.items) { (table, row, message) in
            return self.cellForMessage(message: message)
        }.disposed(by: self.viewModel.disposeBag)
    }
    
    func configureViews() {
        self.messagesTable.register(UserCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
}

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let categorie = self.viewModel.categories.value[indexPath.row]
//        self.viewModel.eventsByFilter(categorie: categorie)
    }
    
    func cellForMessage(message: Message) -> UITableViewCell {
        let cell = self.messagesTable.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! UserCell
        cell.message = message
        return cell
    }
}








