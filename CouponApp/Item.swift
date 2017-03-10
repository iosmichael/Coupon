//
//  Item.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class Item: NSObject {
    var title:String = ""
    var store:Store?
    var detail:String = ""
    var date:String = ""
    var numberOfUses: NSInteger = 0
    var availability:String = ""
    var uid:String = ""
    var uses: Int = 0
}
