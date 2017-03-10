//
//  StoreTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class StoreTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var otherOffer: [Item] = []
    
    var storeImages: [UIImage] = []
    
    var store:Store?
    
    let numberOfStoreImages = 9

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        setupOtherOffers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 3 ? otherOffer.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "store", for: indexPath) as! StoreTitleTableViewCell
            cell.selectionStyle = .none
            cell.setStore(store: store!)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! StoreDetailTableViewCell
            cell.selectionStyle = .none
            cell.setDetail(detail: (store?.detail)!)
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "images", for: indexPath) as! imagesTableViewCell
            cell.selectionStyle = .none
            cell.setCollectionDelegate(delegate: self, datasource: self)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherOffer", for: indexPath) as! OtherOfferTableViewCell
            cell.selectionStyle = .none
            let item = otherOffer[indexPath.row]
            cell.setTitle(offerTitle: item.title, date: item.date)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "couponView") as! CouponTableViewController
            viewController.coupon = otherOffer[indexPath.row]
            viewController.coupon?.store = self.store
            viewController.isFromOtherOffer = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return StoreTitleTableViewCell.getHeight()
        }else if indexPath.section == 1{
            return StoreDetailTableViewCell.getHeight()
        }else if indexPath.section == 2{
            return tableView.frame.width
        }else{
            return OtherOfferTableViewCell.getHeight()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        //Store Detail Header
        case 1:
            return 25
        //Other Offer Detail Header
        case 3:
            return 25
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 8, y: 5, width: 300, height: 20))
        label.font = UIFont.init(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.lightGray
        if section == 1 {
            label.text = "STORE DETAIL"
        }else if section == 3 {
            label.text = "OTHER OFFER"
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
        if store?.imagesURL != nil && indexPath.item < (store?.imagesURL.count)! && storeImages.count <= indexPath.item {
            DispatchQueue.global().async {
                if let url = NSURL(string: (self.store?.imagesURL[indexPath.item])!) {
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
    
    func setupOtherOffers(){
        let itemManager = ItemManager()
        itemManager.getOtherOffers(storeId: (store?.uid)!).observe(.value, with: { (snapshot) in
            self.otherOffer = itemManager.getItems(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
}
