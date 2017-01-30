//
//  Message.swift
//  Chat app
//
//  Created by Jane Hsieh on 1/24/17.
//  Copyright © 2017 Shooting Stars. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String? {
        
//        return fromId = FIRAuth.auth()?.currentUser?.uid ? toId : fromId
        
        if fromId == FIRAuth.auth()?.currentUser?.uid {
            return toId!
        }
        else {
            return fromId!            
        }
    }
    
}
