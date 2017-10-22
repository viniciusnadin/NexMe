//
//  EventListViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import RxSwift

class EventListViewController: UIViewController {
    // MARK:- PROPERTIES
    let viewModel: EventListViewModel
    
    // MARK:- OUTLETS
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.configureBinds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(viewModel: EventListViewModel) {
        self.viewModel = viewModel
        self.viewModel.viewDidLoad()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func configureBinds() {
        self.viewModel.filter.asObservable().bind(to: self.categorieLabel.rx.text).addDisposableTo(self.viewModel.disposeBag)
        self.backButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.events.asObservable().bind(to: table.rx.items) { (table, row, event) in
            return self.cellForEvent(event: event)
            }.addDisposableTo(viewModel.disposeBag)
    }
    
    func configureViews() {
        let cellNib = UINib(nibName: "EventTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "EventTableCell")
        table.separatorColor = UIColor.clear
    }
}

extension EventListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 289
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.viewModel.events.value[indexPath.row]
        self.viewModel.presentEventDetail(event: event)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func cellForEvent(event: Event) -> EventTableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "EventTableCell") as! EventTableViewCell
        cell.eventImage.image = event.image
        cell.eventLocationName.text = event.locationName
        cell.eventNameLabel.text = event.title
        cell.selectionStyle = .none
        let calendar = Calendar.current
        let month = calendar.component(.month, from: event.date)
        let day = calendar.component(.day, from: event.date)
//        let hour = calendar.component(.hour, from: event.date)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months![month-1]
        cell.eventMonthLabel.text = monthSymbol
        cell.eventDayLabel.text = "\(day)"
//        cell.text = "\(hour)h00"
        cell.updateConstraintsIfNeeded()
//        cell.nameLabel.text = user.name.capitalized
//        cell.avatar.kf.setImage(with: user.avatar?.original, placeholder: #imageLiteral(resourceName: "userProfile"), options: nil, progressBlock: nil, completionHandler: nil)
//        cell.updateConstraintsIfNeeded()
        return cell
    }
}






