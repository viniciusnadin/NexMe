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

class EventsViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: EventsViewModel
    
    // MARK: - Outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var newEventButton: UIButton!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
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
        
        let cellNib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.categoriesCollection.register(cellNib, forCellWithReuseIdentifier: "CardCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureBinds() {
        self.menuButton.rx.tap.subscribe(onNext: {
            self.slideMenuController()?.openLeft()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.newEventButton.rx.tap.subscribe(onNext: {
            self.viewModel.newEvent()
        }).addDisposableTo(self.viewModel.disposeBag)
        
        self.viewModel.categories.asObservable().subscribe { _ in
            self.categoriesCollection.reloadData()
        }.addDisposableTo(self.viewModel.disposeBag)
    }

}

extension EventsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(self.viewModel.categories.value[indexPath.row].name)")
    }
}

extension EventsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.categories.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.categoriesCollection.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.categorieName.text = self.viewModel.categories.value[indexPath.row].name
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    
}



