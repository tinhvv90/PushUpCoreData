//
//  ScreenView.swift
//  PushUp
//
//  Created by Student on 2/24/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ScreenView: UIView {
    
    let pushButton                      : UIButton
    var numbersOfPushLabel              : UILabel               = UILabel()
    let finishButton                    : UIButton              = UIButton()
    let maxDayLabel                     : UILabel               = UILabel()
    let sumDayLabel                     : UILabel               = UILabel()
    let newTurnButton                   : UIButton              = UIButton()
    var audioPlayer                     : AVAudioPlayer         = AVAudioPlayer()
    var resetAudioPlayer                : AVAudioPlayer         = AVAudioPlayer()
    var token                           : dispatch_once_t       = 0
    var total = [TurnEntity]()
    
    let moContext = AppDelegate.shareInstance.managedObjectContext
    
    private var isPortrait  = false {
        didSet {
            if isPortrait {
                UIView.animateWithDuration(0.35, animations: animateToPortrait, completion: nil)
            } else {
                UIView.animateWithDuration(0.35, animations: animateToLandscape, completion: nil)
                
            }
        }
    }
    
    private func animateToPortrait() {
        layoutPushButton()
    }
    
    private func animateToLandscape() {
        //        layoutPushButtonRotate()
    }
    
    var vc : ViewController?
    var numbers: Int16 = 0 {
        didSet {
            numbersOfPushLabel.text = "\(numbers)"
        }
    }
    
    static func createButtonCurrent() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Background"), forState: UIControlState.Normal)
        return button
    }
    init(vc: ViewController){
        pushButton = ScreenView.createButtonCurrent()
        super.init(frame: CGRectZero)
        self.vc = vc
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.addSubviews(pushButton)
        pushButton.addTarget(self, action: "countPushUp", forControlEvents: UIControlEvents.TouchUpInside)
        setupAudioPlayer()
        createResetButtonCurrent(newTurnButton, titleButton: "New Turn", selector: "newTurn")
        createResetButtonCurrent(finishButton, titleButton: "Finish", selector: "finish")
//        creataLabelCurrent(maxDayLabel, titleLabel: "Best Record : ")
//        creataLabelCurrent(sumDayLabel, titleLabel: "Sum: ")
        createNumbersOfPushCurrent()
    
    }
    
    private func layoutPushButton() {
        pushButton.mt_InnerAlign(allSpace: 0)
        layoutButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutButtons() {
        let group = UIView()
        self.addSubview(group)
        group.mt_InnerAlign(PinPosition.LowCenter, space: 0, size: CGSize(width: 320, height: 50))
        group.mt_splitVerticallyByViews([finishButton, newTurnButton], edge: UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8), gap: 16)
        let group1 = UIView()
        self.addSubview(group1)
        group1.mt_InnerAlign(PinPosition.HighLeft, space: 80, size: CGSize(width: 160 , height: 100))
        group1.mt_splitHorizontallyByViews([maxDayLabel,sumDayLabel], edge: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), gap: 16)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        dispatch_once(&token) { () -> Void in
        //            self.layoutButtons()
        //            if self.isPortrait {
        //                self.layoutPushButton()
        //            }
        //
        //        }
        layoutPushButton()
    }
    
    private func setupAudioPlayer() {
        audioPlayer = self.setupAudioPlayerWithFile("Ka-Ching", type: "wav")!
        resetAudioPlayer = self.setupAudioPlayerWithFile("Drip", type: "wav")!
    }
    
    func rotation() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            isPortrait = false
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            isPortrait = true
        }
    }
    
    func countPushUp(){
        numbers += 1
        audioPlayer.play()
        audioPlayer.currentTime = 0
        
    }
    
    func newTurn() {
        numbers = 0
        resetAudioPlayer.play()
        resetAudioPlayer.currentTime = 0
    }
    
    func finish() {
        let storeDescription = NSEntityDescription.entityForName("TurnEntity", inManagedObjectContext: moContext)
        
        let store = TurnEntity(entity: storeDescription!, insertIntoManagedObjectContext: moContext)
        
        store.countPushUp = Int(numbersOfPushLabel.text!)
        store.data = NSDate()
        
        var error: NSError?
        
        do {
            try moContext.save()
        }catch {
            
        }
        if let err = error {
            let alert = UIAlertView(title: "Don't Save", message: err.localizedFailureReason!, delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }else {
            let alert = UIAlertView(title: "Save",message: "Success", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
   
    func setupAudioPlayerWithFile(sound: String, type: String) -> AVAudioPlayer? {
        let path = NSBundle.mainBundle().pathForResource(sound as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        var audio : AVAudioPlayer?
        audio = try! AVAudioPlayer(contentsOfURL: url)
        return audio
    }
    
    
}

// MARK: layout if portation
extension ScreenView {
    
    func createNumbersOfPushCurrent() {
        pushButton.addSubview(numbersOfPushLabel)
        numbersOfPushLabel.mt_InnerAlign(PinPosition.Center, space: 30, size: CGSize.init(width: 120, height: 120))
        numbersOfPushLabel.backgroundColor = UIColor.whiteColor()
        numbersOfPushLabel.textColor = UIColor.blackColor()
        numbersOfPushLabel.font = numbersOfPushLabel.font.fontWithSize(70)
        numbersOfPushLabel.textAlignment = NSTextAlignment.Center
        numbersOfPushLabel.layer.cornerRadius = 10
        numbersOfPushLabel.layer.masksToBounds = true
        numbersOfPushLabel.text = "0"
    }
    
    func createResetButtonCurrent(btn: UIButton,titleButton: String, selector: String) -> UIButton {
        
        btn.setTitle(titleButton, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont(name: "GILLSANS", size: 20)
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: Selector(selector) , forControlEvents: UIControlEvents.TouchUpInside)
        btn.backgroundColor = UIColor.redColor()
        return btn
    }
    
    func creataLabelCurrent(label: UILabel,titleLabel: String ) -> UILabel {
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.redColor()
        label.text = titleLabel
        label.font = UIFont(name: "GILLSANS", size: 20)
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textColor = UIColor.whiteColor()
        return label
    }
    
}

extension UIView {
    func addSubviews(views: UIView...) {
        for i in views {
            self.addSubview(i)
        }
    }
    
    
    
}
