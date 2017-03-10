//
//  MessageTableViewController.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageTableViewCell.getHeight()
    }
    
    func getHeaderView() -> UIView {
        let screenBounds:CGRect = self.view.frame
        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 50))
        sectionView.backgroundColor = .white
        let imageView = UIImageView.init(frame: CGRect.init(x: 15, y: 13, width: 22, height: 24))
        imageView.image = UIImage.init(named: "story")!
        let labelText = UILabel.init(frame: CGRect.init(x: 15 * 2 + 22, y: 10, width: screenBounds.width, height: 30))
        labelText.text = "Stories"
        labelText.textColor = .black
        labelText.font = UIFont.init(name: "HelveticaNeue-Medium", size: 23)
        sectionView.addSubview(imageView)
        sectionView.addSubview(labelText)
        return sectionView
    }

}
