//
//  StoreTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var category: UILabel!
    
    static let height:CGFloat = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(icon:UIImage,title:String,category:String){
        self.thumbnail.image = icon
        self.storeTitle.text = title
        self.category.text = category
    }
    
    func setStore(store:Store){
        self.storeTitle.text = store.title
        self.category.text = "Category"
        if store.thumbnailImg == nil{
            self.thumbnail.image = UIImage.init(named: "test-item")
        }else{
            self.thumbnail.image = store.thumbnailImg
            //downloadImage(imageURL: item.thumbnail!)
        }
    }
    
    func setThumbnailImage(image:UIImage){
        self.thumbnail.image = image
        self.setNeedsLayout()
    }
    

    
    class func getHeight() -> CGFloat{
        return height
    }
}
