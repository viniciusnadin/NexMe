//
//  EventDetailViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 22/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class EventDetailViewController: UIViewController {
    // MARK:- PROPERTIES
    let viewModel: EventDetailViewModel
    var googleMapsView : GMSMapView!
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var schedulerLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ownerAvatar: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var envetLocationMap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupGoogleMapsView()
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
            }.disposed(by: self.viewModel.disposeBag)
        
        self.backButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.chatButton.rx.tap.subscribe(onNext: {
            self.viewModel.presentEventMessages()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.joinButton.rx.tap.subscribe(onNext: {
            self.viewModel.subscribeOnEvent()
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    func setupLabels() {
        self.eventTitleLabel.text = self.viewModel.event.value.title.uppercased()
        self.eventImageView.kf.setImage(with: self.viewModel.event.value.image, placeholder: #imageLiteral(resourceName: "imagePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
        self.locationLabel.text = self.viewModel.event.value.locationName
        self.descriptionTextView.text = self.viewModel.event.value.description
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
    
    func setupGoogleMapsView(){
        if self.googleMapsView == nil {
            self.googleMapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.envetLocationMap.frame.width, height: self.envetLocationMap.frame.height))
            let position = self.viewModel.event.value.coordinate
            let camera = GMSCameraPosition.camera(withLatitude: (position.latitude), longitude: (position.longitude), zoom: 18)
            self.googleMapsView.camera = camera
            let marker = GMSMarker(position: position)
            marker.title = self.viewModel.event.value.locationName
            marker.map = self.googleMapsView
            self.envetLocationMap.addSubview(self.googleMapsView)
        }
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
}
