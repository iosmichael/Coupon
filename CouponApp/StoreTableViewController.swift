//
//  StoreTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class StoreTableViewController: UITableViewController {
    
    var otherOffer: [Item] = []
    
    var store:Store?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 1 ? 1 : otherOffer.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "store", for: indexPath) as! StoreTitleTableViewCell
            cell.setStore(store: store!)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! StoreDetailTableViewCell
            cell.setDetail(detail: (store?.detail)!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherOffer", for: indexPath)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return StoreTitleTableViewCell.getHeight()
        }else if indexPath.section == 1{
            return StoreDetailTableViewCell.getHeight()
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
        case 2:
            return 25
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 8, y: 2.5, width: 300, height: 20))
        label.font = UIFont.init(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.lightGray
        if section == 1 {
            label.text = "STORE DETAIL"
        }else if section == 2 {
            label.text = "OTHER OFFER"
        }
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        view.addSubview(label)
        view.backgroundColor = .white
        return view
    }

    
}
