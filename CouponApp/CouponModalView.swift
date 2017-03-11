//
//  CouponModalView.swift
//  CouponApp
//
//  Created by Michael Liu on 3/10/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class CouponModalView: UIView {
    var closeButtonHandler: (() -> Void)?
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var couponTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnail.layer.cornerRadius = self.thumbnail.frame.width/2
        self.thumbnail.layer.borderColor = UIColor.black.cgColor
        self.thumbnail.layer.borderWidth = 2
        self.thumbnail.clipsToBounds = true
    }
    
    class func instantiateFromNib() -> CouponModalView {
        let view = UINib(nibName: "CouponModalView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CouponModalView
        return view
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.closeButtonHandler?()
    }
    
    func setModalView(thumbnail:UIImage, couponTitle:String){
        self.thumbnail.image = thumbnail
        self.couponTitle.text = couponTitle
    }

}
