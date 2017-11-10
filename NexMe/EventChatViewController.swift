//
//  EventChatViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 23/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class EventChatViewController: UIViewController {
    
    // MARK :- PROPERTIES
    let viewModel: EventChatViewModel
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    // MARK :- OUTLETS
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
        self.viewModel.viewDidLoad()
        self.configureViews()
        self.messageTextField.delegate = self
        self.table.estimatedRowHeight = 74
        self.table.rowHeight = UITableViewAutomaticDimension
        setupKeyboardObservers()
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
    }
    
    init(viewModel: EventChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func configureBinds() {
        self.sendButton.rx.tap.subscribe(onNext:{
            self.viewModel.sendMessage()
            self.messageTextField.text = ""
            let lastSectionIndex = self.table.numberOfSections - 1
            let lastRowIndex = self.table.numberOfRows(inSection: lastSectionIndex) - 1
            let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
            if (lastRowIndex >= 0){
                self.table.scrollToRow(at: pathToLastRow, at: UITableViewScrollPosition.none, animated: true)
            }
        }).disposed(by: self.viewModel.disposeBag)
        
        self.messageTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.message)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.messages.asObservable().bind(to: table.rx.items) { (table, row, message) in
            return self.cellForMessage(message: message)
            }.disposed(by: self.viewModel.disposeBag)
        
        self.backButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    func configureViews() {
        let cellNib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "ChatCell")
        table.separatorColor = UIColor.clear
    }

}

extension EventChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let id = self.viewModel.messages.value[indexPath.row].userId
        self.viewModel.useCases.fetchUserById(id: id!) { (result) in
            do{
                let user = try result.getValue()
                self.viewModel.router.presentUserDetail(user: user)
            }catch{
                print("Nao achou usuario")
            }
        }
    }
    
    func cellForMessage(message: EventMessage) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatTableViewCell
        cell.message.text = message.message
        self.viewModel.useCases.fetchUserById(id: message.userId!) { (user) in
            cell.userName.text = user.value?.name!.capitalized
            cell.userAvatar.kf.setImage(with: user.value?.avatar?.original, placeholder: #imageLiteral(resourceName: "placeHolder"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        return cell
    }

    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}

extension EventChatViewController: UITextFieldDelegate {
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
}













