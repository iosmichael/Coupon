//
//  HomeTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
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
        let headerView = HomePageSlideView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.width / 375 * 127))
        headerView.setupScrollView(images: [UIImage.init(named: "banner")!,UIImage.init(named: "banner")!,UIImage.init(named: "banner")!], currentPage: 0)
        self.tableView.tableHeaderView = headerView
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
        print("valueChanged: \(sender.selectedIndex)")
        self.switchIndex = sender.selectedIndex
        self.tableView.reloadData()
    }

    func searchButtonTapped(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "search")
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switchIndex == 0 {
            return itemData.count
        }else{
            return storeData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return switchIndex == 0 ? ItemTableViewCell.getHeight() : StoreTableViewCell.getHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Item
        if switchIndex == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
            cell.selectionStyle = .none
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
        if switchIndex == 0{
            
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "couponView")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getSectionHeader()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func setupElement(){
        let screenBounds = UIScreen.main.bounds
        runkeeperSwitch = DGRunkeeperSwitch(titles: ["Offers", "Stores"])
        runkeeperSwitch?.backgroundColor = UIColor.init(red: 255/255.0, green: 179/255.0, blue: 0/255.0, alpha: 1)
        runkeeperSwitch?.selectedBackgroundColor = .white
        runkeeperSwitch?.titleColor = .white
        runkeeperSwitch?.selectedTitleColor = UIColor.init(red: 255/255.0, green: 179/255.0, blue: 0/255.0, alpha: 1)
        runkeeperSwitch?.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        runkeeperSwitch?.frame = CGRect(x: (screenBounds.width - 250)/2.0, y: 5, width: 250.0, height: 35.0)
        runkeeperSwitch?.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        runkeeperSwitch?.autoresizingMask = [.flexibleWidth]
        searchButton = UIButton.init(frame: CGRect.init(x: screenBounds.width - 15 - 20, y: 12.5, width: 20, height: 20))
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
