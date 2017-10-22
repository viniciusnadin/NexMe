//
//  NewEventViewController.swift
//  NexMe
//
//  Created by Vinicius Nadin on 21/10/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import PopupDialog

class NewEventViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: NewEventViewModel
    var googleMapsView : GMSMapView!
//    var eventLocation : CLLocationCoordinate2D!
//    var eventLocationName : String!
    
    // MARK: - OUTLETS
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationTextField: UILabel!
    

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
        self.nameTextField.delegate = self
        self.configurebinds()
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        let tapOnView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewEventViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapOnView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupGoogleMapsView()
    }
    
    init(viewModel: NewEventViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func configurebinds() {
        self.backButton.rx.tap.subscribe(onNext: {
            self.viewModel.close()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.locationButton.rx.tap.subscribe(onNext: {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            self.present(autocompleteController, animated: true, completion: nil)
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.datePicker.rx.date.map({$0}).bind(to: self.viewModel.date)
            .addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.eventLocationName.asObservable().subscribe(onNext: { name in
            self.locationTextField.text = name
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.nameTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.eventName)
            .addDisposableTo(self.viewModel.disposeBag)
        
        self.descriptionTextField.rx.text.orEmpty.map({$0})
            .bind(to: self.viewModel.eventDescription)
        .addDisposableTo(self.viewModel.disposeBag)
        
        self.saveButton.rx.tap.subscribe(onNext: {
            self.viewModel.save()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.categories.asObservable().subscribe({_ in 
            self.categoryPicker.reloadAllComponents()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        viewModel.errorMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                PopUpDialog.present(title: "Ops!", message: message, viewController: self)
            }).addDisposableTo(viewModel.disposeBag)
        
        viewModel.successMessage.asObservable().filter({!$0.isEmpty})
            .subscribe(onNext: { message in
                let pop2 = PopupDialog(title: "Sucesso!", message: message, image: nil, buttonAlignment: UILayoutConstraintAxis.horizontal, transitionStyle: PopupDialogTransitionStyle.fadeIn, gestureDismissal: true, completion: {
                    self.viewModel.successCreation.value = true
                })
                self.present(pop2, animated: true, completion: nil)
            }).addDisposableTo(viewModel.disposeBag)
        
        self.viewModel.successCreation.asObservable().bind { (verify) in
            if verify{self.viewModel.close()}
            }.addDisposableTo(self.viewModel.disposeBag)
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupGoogleMapsView(){
        if self.googleMapsView == nil {
            self.googleMapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height))
            self.mapView.addSubview(self.googleMapsView)
        }
    }
}

extension NewEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.dismissKeyboard()
        }
        return false
    }
}

extension NewEventViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.locationTextField.text = place.name
        let position = place.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 18)
        self.googleMapsView.camera = camera
        let marker = GMSMarker(position: position)
        marker.title = place.name
        marker.map = self.googleMapsView
        self.viewModel.eventLocation = position
        self.viewModel.eventLocationName.value = place.formattedAddress!
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension NewEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.categories.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.categories.value[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.categorie = self.viewModel.categories.value[row]
    }
}
