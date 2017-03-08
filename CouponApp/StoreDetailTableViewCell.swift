//
//  StoreDetailTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/8/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class StoreDetailTableViewCell: UITableViewCell {
    static let height:CGFloat = 77

    @IBOutlet weak var detail: UILabel!
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
    
    func setDetail(detail:String){
        self.detail.text = detail
    }

}

class OtherOfferTableViewCell: UITableViewCell {
    static let height:CGFloat = 77
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


class StoreTitleTableViewCell: UITableViewCell {
    static let height:CGFloat = 77
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var category: UILabel!
    
    
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
    
    func setStore(store:Store){
        self.storeName.text = store.title
        self.category.text = "Shopping & Clothing"
        if store.thumbnailImg == nil{
            self.thumbnail.image = UIImage.init(named: "amazon")
        }else{
            self.thumbnail.image = store.thumbnailImg
        }
    }
}

