//
//  CouponTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import MapKit

class CouponTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, toolsTableViewCellDelegate, CountDownTableViewCellDelegate {
    
    let numberOfSection = 6

    var isFromOtherOffer = false
    
    var coupon:Item?
    var timer:CountdownLabel?
    var storeImages: [UIImage] = [UIImage.init(named: "t1")!,UIImage.init(named: "t1")!,UIImage.init(named: "t1")!,UIImage.init(named: "t1")!,UIImage.init(named: "t1")!,UIImage.init(named: "t1")!,UIImage.init(named: "t1")!,UIImage.init(named: "t1")!,UIImage.init(named: "t1")!]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "item")
        self.tableView.separatorStyle = .none
        timer = CountdownLabel.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 40), minutes: 440)
        timer?.font = UIFont.init(name: "Avenir-Black", size: 30)
        timer?.textAlignment = .center
        timer?.textColor = .white
        timer?.start()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "item") as! ItemTableViewCell
            cell.selectionStyle = .none
            cell.setItem(item: coupon!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "countdown") as! CountDownTableViewCell
            cell.selectionStyle = .none
            cell.contentView.addSubview(timer!)
            cell.setDelegate(delegate: self)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "offer") as! offerTableViewCell
            cell.selectionStyle = .none
            cell.setOfferDetail(detail: (coupon?.detail)!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tools") as! toolsTableViewCell
            cell.selectionStyle = .none
            cell.setDelegate(delegate: self)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "images") as! imagesTableViewCell
            cell.selectionStyle = .none
            cell.setCollectionDelegate(delegate: self, datasource: self)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info") as! infoTableViewCell
            cell.selectionStyle = .none
            return cell
        //will never get here
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "images") as! imagesTableViewCell
            cell.setCollectionDelegate(delegate: self, datasource: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return ItemTableViewCell.getHeight()
        case 1:
            return 92 // Countdown Timer Height
        case 2:
            return offerTableViewCell.getHeight()
        case 3:
            return 80
        case 4:
            return tableView.frame.width
        case 5:
            return infoTableViewCell.getHeight()
        //will never get here
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        //Offer Detail Header
        case 2:
            return 25
        //Info Detail Header
        case 5:
            return 25
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 8, y: 2.5, width: 300, height: 20))
        label.font = UIFont.init(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.lightGray
        if section == 2 {
            label.text = "OFFER DETAIL"
        }else if section == 5{
            label.text = "INFO"
        }
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        view.addSubview(label)
        view.backgroundColor = .white
        return view
    }
    
    //Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! imageCollectionViewCell
        let image = storeImages[indexPath.item]
        cell.setImage(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentImagePicker(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeImages.count
    }
    
    func presentImagePicker(indexPath:IndexPath){
        let presentImageC = ImagePresenterViewController()
        presentImageC.images = storeImages
        presentImageC.currentPage = indexPath.item
        present(presentImageC, animated: true, completion: nil)
    }
    
    // Custom Delegates
    
    func locationBtnClicked() {
        print("Location clicked")
        //Open MapKit
        //And Show Direction
        let latitude: CLLocationDegrees = 41.8705535
        let longtitude:CLLocationDegrees = -87.6380829
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longtitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        if #available(iOS 10.0, *) {
            let placemark = MKPlacemark(coordinate: coordinates)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = coupon?.store?.title
            mapItem.openInMaps(launchOptions: options)
        } else {
            let alert = UIAlertController.init(title: "Cannot Use Map", message: "Please Update Your IOS Version to 10.0+", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func storeBtnClicked() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let storeController = storyboard.instantiateViewController(withIdentifier: "storeDetail") as! StoreTableViewController
        storeController.store = self.coupon?.store
        self.navigationController?.pushViewController(storeController, animated: true)
    }
    
    func getCouponBtnClicked() {
        print ("Get Coupon")
    }
    

}
