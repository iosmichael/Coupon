//
//  CouponTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import MapKit

class CouponTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, toolsTableViewCellDelegate, CountDownTableViewCellDelegate,CountdownLabelDelegate {
    
    let numberOfSection = 5

    var isFromOtherOffer = false
    
    var coupon:Item?
    var timer:CountdownLabel?
    var storeImages: [UIImage] = []
    let numberOfStoreImages = 9
    var isActive = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "item")
        self.tableView.separatorStyle = .none
        
        let currentDate = Date()
        let dueDate = currentDate.convertStringToDueDate(date: (coupon?.due)!)
        timer = CountdownLabel.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 40), fromDate: currentDate, targetDate: dueDate)
        timer?.font = UIFont.init(name: "Avenir-Black", size: 30)
        timer?.textAlignment = .center
        timer?.textColor = .white
        timer?.countdownDelegate = self
        timer?.start()
        incrementStoreVisit()
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
            if !isActive {
                cell.disableBtn()
            }
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
            cell.setUsage(uses: "\((coupon?.uses)!)")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "images") as! imagesTableViewCell
            cell.selectionStyle = .none
            cell.setCollectionDelegate(delegate: self, datasource: self)
            return cell
        //will never get here
        default: return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let itemCell:ItemTableViewCell = cell as! ItemTableViewCell
            if coupon?.store?.thumbnail != nil {
                DispatchQueue.global().async {
                    if let url = NSURL(string: (self.coupon?.store?.thumbnail)!) {
                        if let data = NSData(contentsOf: url as URL) {
                            let thumbnailImg = UIImage.init(data: data as Data!)
                            self.coupon?.store?.thumbnailImg = thumbnailImg
                            DispatchQueue.main.async {
                                itemCell.setThumbnailImage(image: thumbnailImg!)
                            }
                        }
                    }
                }
            }
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "images") as! imagesTableViewCell
            cell.setCollectionDelegate(delegate: self, datasource: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return ItemTableViewCell.getHeight(title: (coupon?.title)!)
        case 1:
            return 92 // Countdown Timer Height
        case 2:
            return offerTableViewCell.getHeight(detail: (coupon?.detail)!)
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
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 8, y: 2.5, width: 300, height: 20))
        label.font = UIFont.init(name: "HelveticaNeue", size: 16)
        label.textColor = UIColor.lightGray
        if section == 2 {
            label.text = "OFFER DETAIL"
        }
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        view.addSubview(label)
        view.backgroundColor = .white
        return view
    }
    
    //Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! imageCollectionViewCell
        if indexPath.item < storeImages.count {
            let image = storeImages[indexPath.item]
            cell.setImage(image: image)
        }else{
            let image = UIImage.init(named: "t1")!
            cell.setImage(image: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if coupon?.store?.imagesURL != nil && indexPath.item < (coupon?.store?.imagesURL.count)! && storeImages.count <= indexPath.item {
            DispatchQueue.global().async {
                if let url = NSURL(string: (self.coupon?.store?.imagesURL[indexPath.item])!) {
                    if let data = NSData(contentsOf: url as URL) {
                        let storeImg = UIImage.init(data: data as Data!)
                        let imageCell:imageCollectionViewCell = cell as! imageCollectionViewCell
                        self.storeImages.insert(storeImg!, at: 0)
                        DispatchQueue.main.async {
                            imageCell.setImage(image: storeImg!)
                        }
                    }
                }
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentImagePicker(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfStoreImages
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
        if coupon?.store?.latitude == nil || coupon?.store?.longtitude == nil {
            let alert = UIAlertController.init(title: "Location Unavailable", message: "The store has not yet shown its location", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if #available(iOS 10.0, *) {
            let latitude: CLLocationDegrees = CLLocationDegrees.init((coupon?.store?.latitude)!)
            let longtitude:CLLocationDegrees = CLLocationDegrees.init((coupon?.store?.longtitude)!)
            let regionDistance:CLLocationDistance = 1000
            let coordinates = CLLocationCoordinate2DMake(latitude, longtitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
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
        if isFromOtherOffer {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let storeController = storyboard.instantiateViewController(withIdentifier: "storeDetail") as! StoreTableViewController
        storeController.store = self.coupon?.store
        self.navigationController?.pushViewController(storeController, animated: true)
    }
    
    func getCouponBtnClicked() {
        print ("Get Coupon")
        let view = CouponModalView.instantiateFromNib() 
        if self.coupon?.store?.thumbnailImg != nil {
            view.setModalView(thumbnail: (self.coupon?.store?.thumbnailImg)!, couponTitle: (self.coupon?.title)!)
        }else{
            view.setModalView(thumbnail: UIImage.init(named: "amazon")!, couponTitle: (self.coupon?.title)!)
        }
        let window = UIApplication.shared.delegate?.window
        let modal = PopupModal.show(modalView: view, inView: window!!)
        view.closeButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        let userDefault = UserDefaults.standard
        if(userDefault.value(forKey: (self.coupon?.uid)!)==nil){
            let itemManager = ItemManager()
            itemManager.incrementUses(itemId: (coupon?.uid)!)
            userDefault.setValue(1, forKey: (self.coupon?.uid)!)
        }
    }
    
    func incrementStoreVisit(){
        let storeManager = StoreManager()
        storeManager.incrementVisits(storeId: (coupon?.store?.uid)!)
    }
    
    
    // LTMorphingLabel Delegate
    
    func countdownFinished() {
        //Do something here
        let itemManager = ItemManager()
        itemManager.deleteItem(itemId: (self.coupon?.uid)!)
        isActive = false
        self.tableView.reloadData()
    }

}
