//
//  AboutTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/22/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "about", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func getHeaderView() -> UIView {
        let screenBounds:CGRect = self.view.frame
        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 50))
        sectionView.backgroundColor = .white
        let imageView = UIImageView.init(frame: CGRect.init(x: 15, y: 13, width: 24, height: 22))
        imageView.image = UIImage.init(named: "gmail")!
        let labelText = UILabel.init(frame: CGRect.init(x: 15 * 2 + 24, y: 11, width: screenBounds.width, height: 30))
        labelText.text = "Contact"
        labelText.textColor = .black
        labelText.font = UIFont.init(name: "HelveticaNeue-Medium", size: 23)
        sectionView.addSubview(imageView)
        sectionView.addSubview(labelText)
        return sectionView
    }
}
