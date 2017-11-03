//
//  ProfileViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 11/09/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import FontAwesome_swift
import PopupDialog

class ProfileViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: ProfileViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableEvents: UITableView!
    @IBOutlet weak var eventsCount: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    // MARK :- Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.configureBinds()
        self.viewModel.viewDidLoad()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK :- Methods
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.changePasswordButton.rx.tap.subscribe(onNext: {
            self.viewModel.passwordReset()
            let pop = PopupDialog(title: "Redifinição da senha", message: "Enviamos em seu email instruções para redefinir sua senha :)")
            self.present(pop, animated: true, completion: nil)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.name.asObservable()
            .bind(to: nameLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        self.viewModel.following.asObservable().subscribe({_ in
            self.followingButton.setTitle("\(self.viewModel.following.value.count)", for: .normal)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.followers.asObservable().subscribe({_ in
            self.followersButton.setTitle("\(self.viewModel.followers.value.count)", for: .normal)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.events.asObservable().subscribe { (events) in
            self.eventsCount.setTitle("\(events.element!.count)", for: .normal)
        }.disposed(by: viewModel.disposeBag)
        
        self.viewModel.email.asObservable()
            .bind(to: emailLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        self.viewModel.avatarImageURL.asObservable().subscribe({ avatar in
            self.avatar.kf.setImage(with: self.viewModel.avatarImageURL.value, placeholder: #imageLiteral(resourceName: "userProfile"), options: nil, progressBlock: nil, completionHandler: nil)
        }).disposed(by: viewModel.disposeBag)
        
        self.viewModel.events.asObservable().bind(to: tableEvents.rx.items) { (table, row, event) in
            return self.cellForEvent(event: event)
        }.disposed(by: viewModel.disposeBag)
    }
    
    func configureViews() {
        let cellNib = UINib(nibName: "EventLesserCell", bundle: nil)
        tableEvents.register(cellNib, forCellReuseIdentifier: "EventCell")
        tableEvents.separatorColor = UIColor.clear
    }

}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.viewModel.events.value[indexPath.row]
        self.viewModel.router.presentEventDetail(event: event)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func cellForEvent(event: Event) -> EventLesserCell {
        let cell = self.tableEvents.dequeueReusableCell(withIdentifier: "EventCell") as! EventLesserCell
        cell.nameLabel.text = event.title
        cell.locationLabel.text = event.locationName
        cell.selectionStyle = .none
        let calendar = Calendar.current
        let month = calendar.component(.month, from: event.date)
        let day = calendar.component(.day, from: event.date)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![month-1]
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: event.date)
        cell.monthLabel.text = monthSymbol
        cell.dayLabel.text = "\(day)"
        cell.scheduleLabel.text = "\(date24)"
        cell.updateConstraintsIfNeeded()
        return cell
    }
}

