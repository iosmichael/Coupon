//
//  SearchViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/6/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var itemData:[Item] = []
    var storeData:[Store] = []
    var isItem:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Item")
        self.tableView.register(UINib.init(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "Store")
        self.searchBar.delegate = self
        if isItem{
            self.searchBar.placeholder = "Search Coupon"
        }else{
            self.searchBar.placeholder = "Search Store"
        }
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        query()
    }
    
    //MARK: - TableView Control Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isItem ? itemData.count : storeData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
            cell.selectionStyle = .none
            cell.setItem(item: itemData[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Store", for: indexPath) as! StoreTableViewCell
            cell.selectionStyle = .none
            cell.setStore(store: storeData[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isItem{
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if isItem {
            let viewController = storyboard.instantiateViewController(withIdentifier: "couponView") as! CouponTableViewController
            viewController.coupon = itemData[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let viewController = storyboard.instantiateViewController(withIdentifier: "storeDetail") as! StoreTableViewController
            viewController.store = storeData[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isItem ? ItemTableViewCell.getHeight() : StoreTableViewCell.getHeight()
    }
    
    func setupData(){
        if isItem {
            let itemManager = ItemManager()
            itemManager.queryNew(limit: 20).observe(.value, with: { (snapshot) in
                self.itemData = itemManager.getItems(snapshot: snapshot)
                self.tableView.reloadData()
            })
        }else{
            let storeManager = StoreManager()
            storeManager.queryNew(limit: 20).observe(.value, with: { (snapshot) in
                self.storeData = storeManager.getStores(snapshot: snapshot)
                self.tableView.reloadData()
            })
        }
    }
    
    func query(){
        if isItem {
            let itemManager = ItemManager()
            itemManager.queryBySearchStr(limit: 20, query: searchBar.text!).observe(.value, with: { (snapshot) in
                self.itemData = itemManager.getItems(snapshot: snapshot)
                self.tableView.reloadData()
            })
        }else{
            let storeManager = StoreManager()
            storeManager.queryBySearchStr(limit: 20, query: searchBar.text!).observe(.value, with: { (snapshot) in
                self.storeData = storeManager.getStores(snapshot: snapshot)
                self.tableView.reloadData()
            })
        }
    }
    
}
