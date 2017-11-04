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
import CoreLocation
import GooglePlaces

class EventsViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: EventsViewModel
    let locationManager = CLLocationManager()
    
    // MARK: - Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var newEventButton: UIButton!
    @IBOutlet weak var categoriesTable: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainCategorieImage: UIImageView!
    @IBOutlet weak var nearbyEvents: UIButton!
    
    init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
        self.viewModel.viewDidLoad()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBinds()
        self.configureViews()
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(red: 40/255, green: 56/255, blue: 77/255, alpha: 0.4).cgColor
        self.mainCategorieImage.image = UIImage.fontAwesomeIcon(code: "fa-globe", textColor: UIColor(red: 40/255, green: 56/255, blue: 77/255, alpha: 1.0), size: CGSize(width: 50, height: 50))
        
        self.locationManager.requestWhenInUseAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.newEventButton.rx.tap.subscribe(onNext: {
            self.viewModel.newEvent()
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.categories.asObservable().bind(to: categoriesTable.rx.items) { (table, row, categorie) in
            return self.cellForCategorie(categorie: categorie)
        }.disposed(by: viewModel.disposeBag)
        
        self.nearbyEvents.rx.tap.subscribe(onNext: {
            self.locationManager.requestWhenInUseAuthorization()
            GMSPlacesClient.provideAPIKey("AIzaSyBjGjZ-8f2ys2LHIktgpMH3crZb1ljhpfg")
            if CLLocationManager.locationServicesEnabled() {
                GMSPlacesClient.shared().currentPlace { (places, error) in
                    if let error = error {
                        // TODO: Handle the error.
                        print("Current Place error: \(error.localizedDescription)")
                        return
                    }
                    if let likelihoodList = places {
                        for likelihood in likelihoodList.likelihoods {
                            let place = likelihood.place
                            let fullAddress = place.addressComponents
                            for address in fullAddress! {
                                if (address.type == "administrative_area_level_2"){
                                    self.viewModel.router.presentEventsByFilter(categorie: nil, city: address.name)
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }).disposed(by: self.viewModel.disposeBag)
    }

    func configureViews() {
        let cellNib = UINib(nibName: "CategorieTableViewCell", bundle: nil)
        self.categoriesTable.register(cellNib, forCellReuseIdentifier: "CategorieCell")
        self.categoriesTable.separatorColor = UIColor.clear
    }
}

extension EventsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorie = self.viewModel.categories.value[indexPath.row]
        self.viewModel.eventsByFilter(categorie: categorie, city: nil)
    }
    
    func cellForCategorie(categorie: EventCategorie) -> CategorieTableViewCell {
        let cell = self.categoriesTable.dequeueReusableCell(withIdentifier: "CategorieCell") as! CategorieTableViewCell
        cell.categorieNameLabel.text = categorie.name
        return cell
    }
}



