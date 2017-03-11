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
    
    func getCellHeight()->CGFloat{
        return detail.intrinsicContentSize.height + 8*2
    }
    
    class func getHeight(detail:String) -> CGFloat{
        let labelWidth = UIScreen.main.bounds.width-8*2
        let font = UIFont.init(name: "HelveticaNeue", size: 16)
        return UILabel().calculateLabelHeight(labelWidth: labelWidth, content: detail, font: font!) + 8
    }
    
    func setDetail(detail:String){
        self.detail.text = detail
    }

}

class OtherOfferTableViewCell: UITableViewCell {
    static let height:CGFloat = 76.5
    
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setTitle(offerTitle:String, date:String){
        self.offerTitle.text = offerTitle
        self.date.text = date
        self.setNeedsLayout()
    }
    
    class func getHeight(title:String) -> CGFloat{
        let labelWidth = UIScreen.main.bounds.width - 8 - 8
        let actualHeight = UILabel().calculateLabelHeight(labelWidth: labelWidth, content: title, font: UIFont.init(name: "HelveticaNeue-Medium", size: 16)!) + 8 + 30.5
        return actualHeight
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
        self.thumbnail.layer.cornerRadius = self.thumbnail.frame.width/2
        self.thumbnail.layer.borderColor = UIColor.black.cgColor
        self.thumbnail.layer.borderWidth = 1
        self.thumbnail.clipsToBounds = true
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
        self.category.text = store.category
        if store.thumbnailImg == nil{
            self.thumbnail.image = UIImage.init(named: "amazon")
        }else{
            self.thumbnail.image = store.thumbnailImg
        }
    }
}


