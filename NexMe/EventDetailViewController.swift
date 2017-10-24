//
//  EventDetailViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    // MARK:- PROPERTIES
    let viewModel: EventDetailViewModel
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var schedulerLabel: UILabel!
    @IBOutlet weak var participantsCountLabel: UILabel!
    @IBOutlet weak var participantsTable: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ownerAvatar: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(viewModel: EventDetailViewModel) {
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
        self.viewModel.event.asObservable().subscribe { _ in
            self.setupLabels()
        }.addDisposableTo(self.viewModel.disposeBag)
        
        self.backButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.chatButton.rx.tap.subscribe(onNext: {
            self.viewModel.presentEventMessages()
        }).addDisposableTo(self.viewModel.disposeBag)
    }
    
    func setupLabels() {
        self.eventTitleLabel.text = self.viewModel.event.value.title.uppercased()
//        self.eventImageView.image = self.viewModel.event.value.image
        self.locationLabel.text = self.viewModel.event.value.locationName
        self.descriptionTextView.text = self.viewModel.event.value.description
//        self.ownerName.text = self.viewModel.event.value.owner?.name
        let date = self.viewModel.event.value.date
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.monthSymbols
        let monthSymbol = months![month-1]
        self.schedulerLabel.text = "\(day) de \(monthSymbol) de \(year) as \(hour)horas e \(minute) minutos"
    }

}

extension EventDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let user = self.viewModel.events.value[indexPath.row]
        //        self.viewModel.presentUserDetail(user: user)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
//    func cellForEvent(event: Event) -> EventTableViewCell {
//        let cell = self.table.dequeueReusableCell(withIdentifier: "EventTableCell") as! EventTableViewCell
//        cell.eventImage.image = event.image
//        cell.eventLocationName.text = event.locationName
//        cell.eventNameLabel.text = event.title
//        cell.selectionStyle = .none
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: event.date)
//        let day = calendar.component(.day, from: event.date)
//        //        let hour = calendar.component(.hour, from: event.date)
//        let dateFormatter: DateFormatter = DateFormatter()
//        let months = dateFormatter.shortMonthSymbols
//        let monthSymbol = months![month-1]
//        cell.eventMonthLabel.text = monthSymbol
//        cell.eventDayLabel.text = "\(day)"
//        //        cell.text = "\(hour)h00"
//        cell.updateConstraintsIfNeeded()
//        //        cell.nameLabel.text = user.name.capitalized
//        //        cell.avatar.kf.setImage(with: user.avatar?.original, placeholder: #imageLiteral(resourceName: "userProfile"), options: nil, progressBlock: nil, completionHandler: nil)
//        //        cell.updateConstraintsIfNeeded()
//        return cell
//    }
}
