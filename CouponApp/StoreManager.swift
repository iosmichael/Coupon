//
//  StoreManager.swift
//  CouponApp
//
//  Created by Michael Liu on 3/6/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class StoreManager: NSObject {
    var storeRef:FIRDatabaseReference?
    
    override init() {
        super.init()
        storeRef = FIRDatabase.database().reference().child("stores")
    }
    
    func queryNew(limit:Int)->FIRDatabaseQuery{
        return (storeRef?.queryLimited(toLast: UInt(limit)))!
    }
    
    func queryBySearchStr(limit:Int, query:String)->FIRDatabaseQuery{
        return (storeRef?.queryLimited(toLast: UInt(limit)).queryOrdered(byChild: "name").queryStarting(atValue: query))!
    }

    public func getStores(snapshot:FIRDataSnapshot)->[Store]{
        var stores = [Store]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let store = Store()
            store.uid = child.key
            print("snapshot --------> \(snapshot)")
            print("child --------> \(child)")
            for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
                switch elem.key {
                case "name":
                    store.title = elem.value as! String!
                    break
                case "detail":
                    store.detail = elem.value as! String!
                    break
                case "thumbnail":
                    store.thumbnail = elem.value as! String!
                    break
                case "images":
                    for url in elem.value as! [String:String] {
                        store.imagesURL.insert(url.value, at: 0)
                    }
                    break
                case  "date":
                    store.date = elem.value as! String!
                    break
                case "tags":
                    break
                default:
                    break
                }
            }
            stores.append(store)
        }
        return stores
    }

}
