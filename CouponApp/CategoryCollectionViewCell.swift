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
        self.thumbnail.layer.cornerRadius = self.thumbnail.frame.width/2
        self.thumbnail.layer.masksToBounds = true
        self.thumbnail.layer.borderWidth = 1
        self.thumbnail.layer.borderColor = UIColor.black.cgColor
    }
    
    func setCategoryCellTitle(title:String){
        self.title.text = title
    }
    
    func setCategoryCell(icon:UIImage){
        self.thumbnail.image = icon
        self.setNeedsLayout()
    }

}
