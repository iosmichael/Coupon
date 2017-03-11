//
//  HomeTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, HomePageSlideViewDelegate {
    var banners:[Item] = []
    var headerView:HomePageSlideView?
    
    var categories:[(String,String)] = []
    var categoryImages:[UIImage] = []
    var categoryCollectionView: UICollectionView?
    
    var switchIndex = 0
    var itemData:[Item] = []
    var storeData:[Store] = []
    var runkeeperSwitch:DGRunkeeperSwitch?
    var searchButton:UIButton?
    
    let initialQueryLimits = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Item")
        self.tableView.register(UINib.init(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "Store")
        self.tableView.register(UINib.init(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Category")
        headerView = HomePageSlideView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.width / 375 * 163))
        setupCategories()
        setupBanners()
        self.tableView.separatorStyle = .none
        self.setupElement()
        self.setupDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Controls
    
    func switchValueDidChange(sender: DGRunkeeperSwitch!) {
        self.switchIndex = sender.selectedIndex
        self.tableView.reloadData()
    }

    func searchButtonTapped(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "search") as! SearchViewController
        if switchIndex != 0 {
            searchViewController.isItem = false
        }
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if switchIndex == 0 {
                return itemData.count
            }else{
                return storeData.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if categories.count == 0 { return 0 }
            return CategoryTableViewCell.getHeight()
        }else{
            return switchIndex == 0 ? ItemTableViewCell.getHeight(title: (itemData[indexPath.row].title)) : StoreTableViewCell.getHeight()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath) as! CategoryTableViewCell
            cell.selectionStyle = .none
            self.categoryCollectionView = cell.collectionView
            return cell
        }
        //Item
        if switchIndex == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
            cell.selectionStyle = .none
            let item = itemData[indexPath.row]
            cell.setItem(item: item)
            return cell
        }
        //Store
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Store", for: indexPath) as! StoreTableViewCell
            cell.selectionStyle = .none
            let store = storeData[indexPath.row]
            cell.setStore(store: store)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let categoryCell: CategoryTableViewCell = cell as! CategoryTableViewCell
            categoryCell.setDelegate(delegate: self, datasource: self)
        }else{
            if switchIndex == 0{
                let item = itemData[indexPath.row]
                let itemCell: ItemTableViewCell = cell as! ItemTableViewCell
                if item.store?.thumbnail != nil {
                    DispatchQueue.global().async {
                        if let url = NSURL(string: (item.store?.thumbnail)!) {
                            if let data = NSData(contentsOf: url as URL) {
                                let thumbnailImg = UIImage.init(data: data as Data!)
                                item.store?.thumbnailImg = thumbnailImg
                                DispatchQueue.main.async {
                                    itemCell.setThumbnailImage(image: thumbnailImg!)
                                }
                            }
                        }
                    }
                }
            }else{
                let store = storeData[indexPath.row]
                let storeCell: StoreTableViewCell = cell as! StoreTableViewCell
                if store.thumbnail != nil {
                    DispatchQueue.global().async {
                        if let url = NSURL(string: store.thumbnail) {
                            if let data = NSData(contentsOf: url as URL) {
                                let thumbnailImg = UIImage.init(data: data as Data!)
                                store.thumbnailImg = thumbnailImg
                                DispatchQueue.main.async {
                                    storeCell.setThumbnailImage(image: thumbnailImg!)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if switchIndex == 0 {
            let viewController = storyboard.instantiateViewController(withIdentifier: "couponView") as! CouponTableViewController
            viewController.coupon = itemData[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let viewController = storyboard.instantiateViewController(withIdentifier: "storeDetail") as! StoreTableViewController
            viewController.store = storeData[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? nil : getSectionHeader()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 45
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryCollectionViewCell
        let (name, imageURL) = categories[indexPath.item]
        cell.setCategoryCellTitle(title: name)
        if indexPath.item < categoryImages.count {
            cell.setCategoryCell(icon: UIImage.init(named: "amazon")!)
        }else{
            DispatchQueue.global().async {
                if let url = NSURL(string: imageURL) {
                    if let data = NSData(contentsOf: url as URL) {
                        let catImg = UIImage.init(data: data as Data!)
                        self.categoryImages.insert(catImg!, at: 0)
                        DispatchQueue.main.async {
                            cell.setCategoryCell(icon: catImg!)
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let categoryController = storyboard.instantiateViewController(withIdentifier: "category") as! CategoryViewController
        let (category, _) = categories[indexPath.row]
        categoryController.category = category
        self.navigationController?.pushViewController(categoryController, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func setupCountdownLabels(){
        for banner in self.banners {
            let currentDate = Date()
            let dueDate = currentDate.convertStringToDueDate(date: banner.due)
            let countdown = CountdownLabel.init(frame: CGRect.init(x: 0, y: 0, width: 170, height: 50), fromDate: currentDate, targetDate: dueDate)
            //countdown.backgroundColor = UIColor.init(red: 255/255.0, green: 182/255.0, blue: 0, alpha: 1)
            countdown.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            countdown.textColor = .white
            countdown.font = UIFont.init(name: "Avenir-Black", size: 30)
            countdown.textAlignment = .center
            countdown.start()
            banner.countdown = countdown
        }
    }
    
    func setupElement(){
        let screenBounds = UIScreen.main.bounds
        runkeeperSwitch = DGRunkeeperSwitch(titles: ["Offers", "Stores"])
        runkeeperSwitch?.backgroundColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        runkeeperSwitch?.selectedBackgroundColor = .white
        runkeeperSwitch?.titleColor = .white
        runkeeperSwitch?.selectedTitleColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        runkeeperSwitch?.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        runkeeperSwitch?.frame = CGRect(x: (screenBounds.width - 250)/2.0, y: 5, width: 250.0, height: 35.0)
        runkeeperSwitch?.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        runkeeperSwitch?.autoresizingMask = [.flexibleWidth]
        searchButton = UIButton.init(frame: CGRect.init(x: screenBounds.width - 10 - 20, y: 12.5, width: 20, height: 20))
        searchButton?.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton?.setImage(UIImage.init(named: "search"), for: .normal)

    }
    
    func getSectionHeader() -> UIView {
        let screenBounds = UIScreen.main.bounds
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 45))
        view.backgroundColor = .white
        view.addSubview(searchButton!)
        view.addSubview(runkeeperSwitch!)
        return view
    }
    
    func setupCategories(){
        let configManager = ConfigManager()
        let storage = FIRStorage.storage()
        configManager.getCategories { (categories) in
            for category in categories{
                let gsReference = storage.reference(withPath: "categories/"+category+"-icon.png")
                gsReference.downloadURL(completion: { (url, error) in
                    self.categories.append((category,(url?.absoluteString)!))
                    self.tableView.reloadData()
                    self.categoryCollectionView?.reloadData()
                })
            }
        }
    }
    
    func setupBanners(){
        let itemManager = ItemManager()
        itemManager.queryBanners().observe(.value, with: { (snapshot) in
            let banners = itemManager.getItems(snapshot: snapshot)
            self.banners = banners
            self.setupCountdownLabels()
            self.setupBannerImages()
        })
    }
    
    func setupBannerImages(){
        for banner in banners{
            if banner.bannerDownloadImage == nil{
                self.reloadBannerTableHeader()
            }else{
                DispatchQueue.global().async {
                    if let url = NSURL(string: banner.bannerImg!) {
                        if let data = NSData(contentsOf: url as URL) {
                            let bannerImg = UIImage.init(data: data as Data!)
                            DispatchQueue.main.async {
                                banner.bannerDownloadImage = bannerImg
                                self.reloadBannerTableHeader()
                            }
                        }
                    }
                }
            }
        }

    }
    
    func pageTapped(pageIndex: Int) {
        let item = banners[pageIndex]
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let couponController = storyboard.instantiateViewController(withIdentifier: "couponView") as! CouponTableViewController
        couponController.coupon = item
        self.navigationController?.pushViewController(couponController, animated: true)
    }
    
    func reloadBannerTableHeader(){
        var bannerImages:[UIImage] = []
        var countdowns:[CountdownLabel] = []
        for banner in banners{
            if banner.bannerDownloadImage == nil{
                bannerImages.append(UIImage.init(named: "banner")!)
            }else{
                bannerImages.append(banner.bannerDownloadImage!)
            }
            countdowns.append(banner.countdown!)
        }
        headerView?.setupScrollView(images: bannerImages, labels: countdowns, currentPage: 0)
        self.tableView.tableHeaderView = headerView!
    }
    
    func setupDatabase(){
        //Setup Stores
        let storeManager = StoreManager()
        storeManager.queryNew(limit: initialQueryLimits).observe(.value, with: { (snapshot) in
            self.storeData = storeManager.getStores(snapshot: snapshot)
            self.tableView.reloadData()
        })
        //Setup Coupons
        let itemManager = ItemManager()
        itemManager.queryNew(limit: initialQueryLimits).observe(.value, with: { (snapshot) in
            self.itemData = itemManager.getItems(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
}
