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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instantiateFromNib() -> CouponModalView {
        let view = UINib(nibName: "CouponModalView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CouponModalView
        return view
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.closeButtonHandler?()
    }

}
