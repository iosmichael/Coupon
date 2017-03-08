//
//  CouponTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class CouponTableViewController: UITableViewController {
    
    let numberOfSection = 4
    
    var coupon:Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "item")
        self.tableView.separatorStyle = .none
        setupContent()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "usage") as! UsageTableViewCell
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "offer") as! offerTableViewCell
            cell.selectionStyle = .none
            cell.setOfferDetail(detail: (coupon?.detail)!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "info") as! infoTableViewCell
            cell.selectionStyle = .none
            return cell
        //will never get here
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return ItemTableViewCell.getHeight()
        case 1:
            return UsageTableViewCell.getHeight()
        case 2:
            return offerTableViewCell.getHeight()
        case 3:
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
        case 3:
            return 25
            break
        default:
            return 0
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 8, y: 2.5, width: 300, height: 20))
        label.font = UIFont.init(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.lightGray
        if section == 2 {
            label.text = "OFFER DETAIL"
        }else if section == 3 {
            label.text = "INFO"
        }
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        view.addSubview(label)
        view.backgroundColor = .white
        return view
    }
    
    func setupContent(){
    
    }

}
