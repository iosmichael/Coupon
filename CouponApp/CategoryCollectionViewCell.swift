//
//  CategoryCollectionViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/8/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCategoryCell(icon:UIImage, title:String){
        self.thumbnail.image = icon
        //Make the thumbnail a circle with cornerRadius half of its height: 50
        self.thumbnail.layer.cornerRadius = 25
        self.thumbnail.clipsToBounds = true
        self.title.text = title
        self.setNeedsLayout()
    }

}
