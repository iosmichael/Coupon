//
//  Extension.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    func convertStringToDueDate(date:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: date)!
    }
    
}

extension UILabel{
    func calculateLabelHeight(labelWidth:CGFloat, content:String, font:UIFont)->CGFloat{
        let label = UILabel.init(frame:CGRect.init(x: 0, y: 0, width: labelWidth, height: 9999))
        label.text = content
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.font = font
        return label.frame.height
    }
}


