//
//  UserDetailViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 19/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Hero

class UserDetailViewController: UIViewController {
    
    // MARK :- Properties
    var viewModel: UserDetailViewModel!
    
    // MARK :- Outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var eventsCount: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
        self.configureBinds()
        self.configureViews()
        let grayColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        let blackColor = UIColor(red: 40/255, green: 56/255, blue: 77/255, alpha: 1.0)
        self.followButton.layer.borderWidth = 1
        self.followButton.layer.borderColor = grayColor.cgColor
        self.followButton.layer.cornerRadius = 5
        self.messageButton.setImage(UIImage.fontAwesomeIcon(code: "fa-envelope", textColor: blackColor, size: CGSize(width: 35, height: 35)), for: .normal)
        if self.viewModel.user.isFollowingUser(){
            self.viewModel.followingThisUser.value = true
            self.followButton.setTitle("seguindo", for: .normal)
        }else{
            self.followButton.setTitle("seguir", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        self.viewModel.router.presentChat(user: self.viewModel.user)
    }
    
    
    func configureBinds() {
        self.backButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.followingThisUser.asObservable().subscribe({ value in
            if value.element! {
                self.followButton.setTitle("seguindo", for: .normal)
            } else {
                self.followButton.setTitle("seguir", for: .normal)
            }
        })
        
        self.followButton.rx.tap.subscribe(onNext: {
            self.viewModel.followUser()
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
        
        self.viewModel.avatarImageURL.asObservable().subscribe(onNext: { avatar in
            self.avatar.kf.setImage(with: self.viewModel.avatarImageURL.value, placeholder: #imageLiteral(resourceName: "userProfile"), options: nil, progressBlock: nil, completionHandler: nil)
        }).disposed(by: viewModel.disposeBag)
        
        self.viewModel.events.asObservable().bind(to: eventsTable.rx.items) { (table, row, event) in
            return self.cellForEvent(event: event)
        }.disposed(by: viewModel.disposeBag)
        
        self.viewModel.events.asObservable().subscribe { (events) in
            self.eventsCount.setTitle("\(events.element!.count)", for: .normal)
        }.disposed(by: viewModel.disposeBag)
        
        
    }
    
    func configureViews() {
        let cellNib = UINib(nibName: "EventLesserCell", bundle: nil)
        self.eventsTable.register(cellNib, forCellReuseIdentifier: "EventCell")
        self.eventsTable.separatorColor = UIColor.clear
    }
    
}

extension UserDetailViewController: UITableViewDelegate {
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
        let cell = self.eventsTable.dequeueReusableCell(withIdentifier: "EventCell") as! EventLesserCell
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
