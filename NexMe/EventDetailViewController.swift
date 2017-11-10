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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var envetLocationMap: UIView!
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var participants: UILabel!
    @IBOutlet weak var participantsIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
        let blueColor = UIColor(red: 82/255, green: 205/255, blue: 171/255, alpha: 1.0)
        self.dateIcon.image = UIImage.fontAwesomeIcon(code: "fa-calendar", textColor: blueColor, size: CGSize(width: 40, height: 40))
        self.locationIcon.image = UIImage.fontAwesomeIcon(code: "fa-map-marker", textColor: blueColor, size: CGSize(width: 40, height: 40))
        self.participantsIcon.image = UIImage.fontAwesomeIcon(code: "fa-users", textColor: blueColor, size: CGSize(width: 40, height: 40))
        self.participatingFunc(value: self.viewModel.participatingThisEvent.value)
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
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
            self.viewModel.tapOnJoin()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.participatingThisEvent.asObservable().subscribe({ value in
            self.participatingFunc(value: value.element!)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.participantsCount.asObservable().subscribe { (value) in
            self.participants.text = "\(value.element!) participantes"
        }.disposed(by: self.viewModel.disposeBag)
    }
    
    func participatingFunc(value: Bool) {
        if self.viewModel.selfEvent() {
            self.joinButton.setTitle("Editar meu evento", for: .normal)
            self.joinButton.backgroundColor = UIColor(red: 249/255, green: 154/255, blue: 0/255, alpha: 1.0)
        }
        else if value{
            self.joinButton.setTitle("Sair", for: .normal)
            self.joinButton.backgroundColor = UIColor(red: 227/255, green: 90/255, blue: 102/255, alpha: 1.0)
        } else {
            self.joinButton.setTitle("Participar", for: .normal)
            self.joinButton.backgroundColor = UIColor(red: 82/255, green: 205/255, blue: 171/255, alpha: 1.0)
        }
    }
    
    func setupLabels() {
        self.eventTitleLabel.text = self.viewModel.event.value.title.uppercased()
        self.eventImageView.kf.setImage(with: self.viewModel.event.value.image, placeholder: #imageLiteral(resourceName: "imagePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
        self.locationLabel.text = self.viewModel.event.value.locationName
        self.descriptionTextView.font = UIFont.fontAwesome(ofSize: 20)
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
        self.schedulerLabel.text = "\(day) de \(monthSymbol) de \(year) as \(hour):\(minute)"
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
