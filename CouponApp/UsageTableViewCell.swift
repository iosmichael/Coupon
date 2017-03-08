//
//  UsageTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class UsageTableViewCell: UITableViewCell {

    static let height:CGFloat = 112
    
    var active = false
    
    @IBOutlet weak var numberOfUses: UILabel!
    @IBOutlet weak var availableText: UILabel!
    @IBOutlet weak var getCouponBtn: UIButton!
    @IBOutlet weak var instructionText: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        getCouponBtn.layer.cornerRadius = 20
        if !active {
            availableText.isHidden = !active
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func getCoupon(_ sender: Any) {
        
    }
    
    class func getHeight() -> CGFloat{
        return height
    }

}


class infoTableViewCell: UITableViewCell {
    static let height:CGFloat = 45
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var websiteURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    class func getHeight() -> CGFloat{
        return height
    }
    
}

class offerTableViewCell:UITableViewCell{
    static let height:CGFloat = 75
    
    @IBOutlet weak var offerText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    class func getHeight() -> CGFloat{
        return height
    }
}

