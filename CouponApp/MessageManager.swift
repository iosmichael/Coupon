//
//  MessageManager.swift
//  CouponApp
//
//  Created by Michael Liu on 3/10/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class MessageManager: NSObject {
    
    var messageRef:FIRDatabaseReference?
    
    override init() {
        super.init()
        messageRef = FIRDatabase.database().reference().child("messages")
    }
    
    func queryNewMessages(limit:Int)->FIRDatabaseQuery{
        return (messageRef?.queryLimited(toLast: UInt(limit)))!
    }
    
    func populatingMessages()->[Message]{
        var messages:[Message] = []
        for i in [0,1,2,3,4,5]{
            let message = Message()
            message.title = "Refer & Earn"
            message.content = "Invite your friends to CouponDunia and spread the cheer! You get Rs. 250 for every friend who joins"
            message.date = "2-18-2017"
            messages.append(message)
        }
        return messages
    }
    
    public func getMessages(snapshot:FIRDataSnapshot)->[Message]{
        var messages = [Message]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let message = Message()
            for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
                switch elem.key {
                case "title":
                    message.title = elem.value as! String!
                    break
                case "content":
                    message.content = elem.value as! String!
                    break
                case  "date":
                    message.date = elem.value as! String!
                    break
                default:
                    break
                }
            }
            messages.insert(message, at: 0)
        }
        return messages
    }

    
}
