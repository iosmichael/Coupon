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
    
    func queryBanners()->FIRDatabaseQuery{
        return (itemRef?.queryOrdered(byChild: "isBanner").queryEqual(toValue: 1))!
    }
    
    func queryBySearchStr(limit:Int, query:String)->FIRDatabaseQuery{
        return (itemRef?.queryLimited(toLast: UInt(limit)).queryOrdered(byChild: "name").queryStarting(atValue: query))!
    }
    
    func getOtherOffers(storeId: String)->FIRDatabaseQuery{
        return (itemRef?.queryOrdered(byChild: "storeId").queryEqual(toValue: storeId))!
    }
    
    func incrementUses(itemId:String){
        let ref = itemRef?.child(itemId)
        ref?.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var item = currentData.value as? [String : AnyObject] {
                var uses = item["uses"] as? Int ?? 0
                uses += 1
                item["uses"] = uses as AnyObject?
                // Set value and report transaction success
                currentData.value = item
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteItem(itemId:String){
        let ref = itemRef?.child(itemId)
        ref?.removeValue()
    }
    
    public func getItems(snapshot:FIRDataSnapshot)->[Item]{
        var items = [Item]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let item = Item()
            let store = Store()
            item.uid = child.key
            print("snapshot --------> \(snapshot)")
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
                case "storeDetail":
                    store.detail = elem.value as! String!
                    break
                case "images":
                    for url in elem.value as! [String] {
                        store.imagesURL.insert(url, at: 0)
                    }
                    break
                case "uses":
                    item.uses = elem.value as? Int ?? 0
                    break
                case "due":
                    item.due = elem.value as! String!
                    break
                case "storeLatitude":
                    store.latitude = elem.value as! Float!
                    break
                case "storeLongtitude":
                    store.longtitude = elem.value as! Float!
                    break
                case "website":
                    store.website = elem.value as! String!
                    break
                case "category":
                    store.category = elem.value as! String!
                    break
                case "bannerImage":
                    item.bannerImg = elem.value as! String!
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
