//
//  ItemTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    static let height:CGFloat = 85
    
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var couponName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.thumbnail.layer.cornerRadius = self.thumbnail.frame.width/2
        self.thumbnail.layer.borderColor = UIColor.black.cgColor
        self.thumbnail.layer.borderWidth = 1
        self.thumbnail.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setItem(item:Item){
        self.storeName.text = item.store?.title
        self.couponName.text = item.title
        self.itemDate.text = item.date
        if item.store?.thumbnailImg == nil{
            self.thumbnail.image = UIImage.init(named: "amazon")
        }else{
            self.thumbnail.image = item.store?.thumbnailImg
            //downloadImage(imageURL: item.thumbnail!)
        }
    }
    
    func setThumbnailImage(image:UIImage){
        self.thumbnail.image = image
        self.setNeedsLayout()
    }
    
    class func getHeight()->CGFloat{
        return height
    }
    
}
