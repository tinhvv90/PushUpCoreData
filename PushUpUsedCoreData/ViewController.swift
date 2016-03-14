//
//  ViewController.swift
//  PushUp
//
//  Created by Student on 2/24/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var pushView                        : ScreenView!
    
    
    @IBAction func historyBarButton(sender: AnyObject) {
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushView = ScreenView(vc: self)
        layoutScreenView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func layoutScreenView() {
        view.addSubview(pushView)
        pushView.mt_innerAlign(left: 0, top: 0, right: 0, bottom: 0)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
}

