//
//  ItemManager.swift
//  CouponApp
//
//  Created by Michael Liu on 3/6/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class ItemManager: NSObject {
    var itemRef:FIRDatabaseReference?
    
    override init() {
        super.init()
        itemRef = FIRDatabase.database().reference().child("coupons")
    }
    
    func queryNew(limit:Int)->FIRDatabaseQuery{
        return (itemRef?.queryLimited(toLast: UInt(limit)))!
    }
    
    func queryBySearchStr(limit:Int, query:String)->FIRDatabaseQuery{
        return (itemRef?.queryLimited(toLast: UInt(limit)).queryOrdered(byChild: "name").queryStarting(atValue: query))!
    }
    
    public func getItems(snapshot:FIRDataSnapshot)->[Item]{
        var items = [Item]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let item = Item()
            let store = Store()
            item.uid = child.key
            print("snapshot --------> \(snapshot)")
            print("child --------> \(child)")
            for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
                switch elem.key {
                case "name":
                    item.title = elem.value as! String!
                    break
                case "detail":
                    item.detail = elem.value as! String!
                    break
                case  "date":
                    item.date = elem.value as! String!
                    break
                //STORE VARIABLE
                case "storeId":
                    store.uid = elem.value as! String!
                    break
                case "storeName":
                    store.title = elem.value as! String!
                    break
                case "storeThumbnail":
                    store.thumbnail = elem.value as! String!
                    break
                default:
                    break
                }
            }
            item.store = store
            items.append(item)
        }
        return items
    }
}
