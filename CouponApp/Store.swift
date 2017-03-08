//
//  Store.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class Store: NSObject {
    var thumbnail:String!
    var thumbnailImg: UIImage!
    var title:String = ""
    var category:String = ""
    var detail:String = ""
    var webpage:String?
    var uid: String = ""
    var date: String = ""
    var imagesURL:[String] = []
}
