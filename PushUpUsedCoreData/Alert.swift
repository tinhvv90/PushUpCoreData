//
//  Alert.swift
//  PushUpUsedCoreData
//
//  Created by Tinh on 4/8/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import UIKit

class Alert: NSObject {
    static func show (title: String, message: String, vc: UIViewController) {
//        Create the Controller
        let alertCT = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        Create Alert Action
        let okAc = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            alertCT.dismissViewControllerAnimated(true, completion: nil)
        }
//        Add Alert action to Alert Controller
        alertCT.addAction(okAc)
        
//        Display Alert Controller
        vc.presentViewController(alertCT, animated: true, completion: nil)
    }
}