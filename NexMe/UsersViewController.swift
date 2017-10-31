//
//  UsersViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 17/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: UsersViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    // MARK :- Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.configureBinds()
        self.searchTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.users.asObservable().bind(to: table.rx.items) { (table, row, user) in
            return self.cellForUser(user: user)
            }.disposed(by: viewModel.disposeBag)
        
        self.searchTextField.rx.text.orEmpty.map({$0})
        .bind(to: self.viewModel.textEntry)
            .disposed(by: self.viewModel.disposeBag)
    }
    
    func configureViews() {
        let cellNib = UINib(nibName: "CardTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "CardCell")
        table.separatorColor = UIColor.clear
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

}

extension UsersViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel.users.value[indexPath.row]
        self.viewModel.presentUserDetail(user: user)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func cellForUser(user: User) -> CardTableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "CardCell") as! CardTableViewCell
    
        cell.nameLabel.text = user.name!.capitalized
        cell.avatar.kf.setImage(with: user.avatar?.original, placeholder: #imageLiteral(resourceName: "userProfile"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    
}

extension UsersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTextField {
            self.dismissKeyboard()
            if !viewModel.textEntry.value.isEmpty{
                self.viewModel.searchUser()
            }
        }
        return false
    }
}


















