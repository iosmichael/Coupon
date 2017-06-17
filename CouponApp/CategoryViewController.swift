//
//  CategoryViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/9/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var category:String?
    
    var isStore:Bool = false
    
    var items:[Item] = []
    
    var stores:[Store] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "Store")
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "Item")
        self.navigationItem.title = category
        // Do any additional setup after loading the view.
        setupDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isStore {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Store") as! StoreTableViewCell
            cell.setStore(store: stores[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item") as! ItemTableViewCell
            cell.setItem(item: items[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isStore {
            let store = stores[indexPath.row]
            let storeCell: StoreTableViewCell = cell as! StoreTableViewCell
            if store.thumbnail != nil {
                DispatchQueue.global().async {
                    if let url = NSURL(string: (store.thumbnail)!) {
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
        }else{
            let item = items[indexPath.row]
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
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isStore ? StoreTableViewCell.getHeight() : ItemTableViewCell.getHeight(title: (items[indexPath.row].title))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isStore {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "storeDetail") as! StoreTableViewController
            viewController.store = stores[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "couponView") as! CouponTableViewController
            viewController.coupon = items[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isStore ? stores.count : items.count
    }
    
    func setupDatabase(){
        if isStore {
            let storeManager = StoreManager()
            storeManager.queryCategory(category: self.category!).observe(.value, with: { (snapshot) in
                self.stores = storeManager.getStores(snapshot: snapshot)
                self.tableView.reloadData()
            })
        }else{
            let itemManager = ItemManager()
            itemManager.queryCategory(category: self.category!).observe(.value, with: { (snapshot) in
                self.items = itemManager.getItems(snapshot: snapshot)
                self.tableView.reloadData()
            })
        }
    }
    
}
